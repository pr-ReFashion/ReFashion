import os
import threading
import time
from typing import Literal, Optional, List, Dict, Any

from fastapi import FastAPI, Query, HTTPException
from psycopg.rows import dict_row
from psycopg_pool import ConnectionPool
from pydantic import BaseModel

# ---- Config ----
DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgres://postgres:postgres@localhost:5432/mercur_db"
).strip()

REFRESH_SECONDS = int(os.getenv("RECOMMENDER_REFRESH_SECONDS", "86400"))  # 1 day
_scheduler_neighbor_limit = 3
_scheduler_product_limit = 3
_scheduler_refresh_seconds = REFRESH_SECONDS

app = FastAPI(title="Recommender Service", version="0.2.0")

pool: Optional[ConnectionPool] = None

_scheduler_thread: Optional[threading.Thread] = None
_scheduler_stop_event = threading.Event()
_scheduler_lock = threading.Lock()
_scheduler_running = False


# -----------------------------
# Startup / shutdown
# -----------------------------
@app.on_event("startup")
def _startup():
    global pool

    if not DATABASE_URL:
        raise RuntimeError("DATABASE_URL is required")

    pool = ConnectionPool(conninfo=DATABASE_URL, min_size=1, max_size=5, open=True)


@app.on_event("shutdown")
def _shutdown():
    stop_scheduler()

    global pool
    if pool:
        pool.close()
        pool = None


# -----------------------------
# Models
# -----------------------------
class NeighborItem(BaseModel):
    customer_id: str
    age: int
    age_diff_days: int
    date_of_birth: str
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    email: Optional[str] = None
    job: Optional[str] = None
    interests: Optional[str] = None


class NeighborProductItem(BaseModel):
    neighbor_customer_id: str
    product_id: Optional[str] = None
    order_id: Optional[str] = None
    order_line_item_id: Optional[str] = None
    source: Optional[str] = None   # "order" | "wishlist"


class RecommendationResponse(BaseModel):
    input_customer_id: str
    input_age: int
    neighbor_count: int
    product_count: int
    neighbors: List[NeighborItem]
    neighbor_products: List[NeighborProductItem]
    recommended_product_ids: List[str]


class ProfileItem(BaseModel):
    entity: Literal["customer", "seller"]
    id: str
    age: int
    date_of_birth: str
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    email: Optional[str] = None
    name: Optional[str] = None
    handle: Optional[str] = None
    job: Optional[str] = None
    interests: Optional[str] = None


class ProfilesResponse(BaseModel):
    entity: Literal["customer", "seller"]
    min_age: int
    max_age: int
    limit: int
    offset: int
    count: int
    items: List[ProfileItem]


# -----------------------------
# Helpers
# -----------------------------
def _require_pool() -> ConnectionPool:
    if not pool:
        raise RuntimeError("DB pool not initialized")
    return pool


def _save_recommendations_to_customer(conn, customer_id: str, product_ids: list[str]):
    p1 = product_ids[0] if len(product_ids) > 0 else None
    p2 = product_ids[1] if len(product_ids) > 1 else None
    p3 = product_ids[2] if len(product_ids) > 2 else None

    with conn.cursor() as cur:
        cur.execute(
            """
            UPDATE public.customer
            SET
              rec_product_id1 = %s,
              rec_product_id2 = %s,
              rec_product_id3 = %s,
              updated_at = now()
            WHERE id = %s
            """,
            (p1, p2, p3, customer_id),
        )


def _compute_recommendations_for_customer(
    conn,
    customer_id: str,
    neighbor_limit: int = 3,
    product_limit: int = 3
):
    with conn.cursor(row_factory=dict_row) as cur:
        # 1) load input customer
        cur.execute(
            """
            SELECT
              id,
              date_of_birth,
              EXTRACT(YEAR FROM age(date_of_birth))::int AS age,
              first_name,
              last_name,
              email,
              job,
              interests
            FROM public.customer
            WHERE id = %s
              AND deleted_at IS NULL
            """,
            (customer_id,),
        )
        input_customer = cur.fetchone()

        if not input_customer:
            return None

        if not input_customer.get("date_of_birth"):
            return {
                "input_customer_id": customer_id,
                "input_age": 0,
                "neighbor_count": 0,
                "product_count": 0,
                "neighbors": [],
                "neighbor_products": [],
                "recommended_product_ids": [],
            }

        input_dob = input_customer["date_of_birth"]
        input_age = int(input_customer["age"])

        # 2) nearest customers by DOB distance
        cur.execute(
            """
            SELECT
            c.id AS customer_id,
            EXTRACT(YEAR FROM age(c.date_of_birth))::int AS age,
            ABS(c.date_of_birth - %s::date)::int AS age_diff_days,
            c.date_of_birth::text AS date_of_birth,
            c.first_name,
            c.last_name,
            c.email,
            c.job,
            c.interests
            FROM public.customer c
            WHERE c.deleted_at IS NULL
            AND c.id <> %s
            AND c.date_of_birth IS NOT NULL
            ORDER BY ABS(c.date_of_birth - %s::date) ASC, c.id ASC
            LIMIT %s
            """,
            (input_dob, customer_id, input_dob, neighbor_limit),
        )
        neighbor_rows = cur.fetchall()
        neighbors = [dict(r) for r in neighbor_rows]

        if not neighbor_rows:
            return {
                "input_customer_id": customer_id,
                "input_age": input_age,
                "neighbor_count": 0,
                "product_count": 0,
                "neighbors": [],
                "neighbor_products": [],
                "recommended_product_ids": [],
            }

        # 3) candidate products from neighbors: ORDERS + WISHLIST
        cur.execute(
            """
            WITH neighbors AS (
            SELECT
                c.id AS customer_id,
                ROW_NUMBER() OVER (
                ORDER BY ABS(c.date_of_birth - %s::date) ASC, c.id ASC
                ) AS neighbor_rank
            FROM public.customer c
            WHERE c.deleted_at IS NULL
                AND c.id <> %s
                AND c.date_of_birth IS NOT NULL
            ORDER BY ABS(c.date_of_birth - %s::date) ASC, c.id ASC
            LIMIT %s
            ),

            order_candidates AS (
            SELECT
                n.customer_id AS neighbor_customer_id,
                oli.product_id,
                o.id AS order_id,
                oi.item_id AS order_line_item_id,
                n.neighbor_rank,
                o.created_at AS order_created_at,
                oi.created_at AS order_item_created_at,
                'order'::text AS source,
                1 AS source_priority
            FROM neighbors n
            JOIN public."order" o
                ON o.customer_id = n.customer_id
            AND o.deleted_at IS NULL
            JOIN public.order_item oi
                ON oi.order_id = o.id
            AND oi.deleted_at IS NULL
            JOIN public.order_line_item oli
                ON oli.id = oi.item_id
            AND oli.deleted_at IS NULL
            WHERE oli.product_id IS NOT NULL
            ),

            wishlist_candidates AS (
            SELECT
                n.customer_id AS neighbor_customer_id,
                wwpp.product_id,
                NULL::text AS order_id,
                NULL::text AS order_line_item_id,
                n.neighbor_rank,
                NULL::timestamptz AS order_created_at,
                NULL::timestamptz AS order_item_created_at,
                'wishlist'::text AS source,
                2 AS source_priority
            FROM neighbors n
            JOIN public.customer_customer_wishlist_wishlist ccww
                ON ccww.customer_id = n.customer_id
            JOIN public.wishlist_wishlist_product_product wwpp
                ON wwpp.wishlist_id = ccww.wishlist_id
            WHERE wwpp.product_id IS NOT NULL
            )

            SELECT
            neighbor_customer_id,
            product_id,
            order_id,
            order_line_item_id,
            neighbor_rank,
            order_created_at,
            order_item_created_at,
            source,
            source_priority
            FROM (
            SELECT * FROM order_candidates
            UNION ALL
            SELECT * FROM wishlist_candidates
            ) AS all_candidates
            ORDER BY
            neighbor_rank ASC,
            source_priority ASC,
            order_created_at DESC NULLS LAST,
            order_item_created_at DESC NULLS LAST,
            product_id ASC
            """,
            (input_dob, customer_id, input_dob, neighbor_limit),
        )
        product_rows = cur.fetchall()

    neighbor_products = []
    recommended_product_ids = []
    seen_products = set()

    for row in product_rows:
        pid = row.get("product_id")
        if not pid:
            continue

        neighbor_products.append(
            {
                "neighbor_customer_id": row["neighbor_customer_id"],
                "product_id": pid,
                "order_id": row["order_id"],
                "order_line_item_id": row["order_line_item_id"],
                "source": row["source"],
            }
        )

        if pid in seen_products:
            continue

        seen_products.add(pid)
        recommended_product_ids.append(pid)

        if len(recommended_product_ids) >= product_limit:
            break

    return {
        "input_customer_id": customer_id,
        "input_age": input_age,
        "neighbor_count": len(neighbors),
        "product_count": len(recommended_product_ids),
        "neighbors": neighbors,
        "neighbor_products": neighbor_products,
        "recommended_product_ids": recommended_product_ids,
    }


def run_recommendations_for_all_customers(
    neighbor_limit: Optional[int] = None,
    product_limit: Optional[int] = None,
):
    p = _require_pool()

    if neighbor_limit is None:
        neighbor_limit = _scheduler_neighbor_limit

    if product_limit is None:
        product_limit = _scheduler_product_limit

    summary = {
        "processed_customers": 0,
        "updated_customers": 0,
        "neighbor_limit": neighbor_limit,
        "product_limit": product_limit,
        "items": [],
    }

    with p.connection() as conn:
        with conn.cursor(row_factory=dict_row) as cur:
            cur.execute(
                """
                SELECT id
                FROM public.customer
                WHERE deleted_at IS NULL
                ORDER BY id ASC
                """
            )
            customers = cur.fetchall()

        for row in customers:
            cid = row["id"]
            summary["processed_customers"] += 1

            try:
                payload = _compute_recommendations_for_customer(
                    conn,
                    cid,
                    neighbor_limit=neighbor_limit,
                    product_limit=product_limit
                )

                if payload is None:
                    continue

                product_ids = payload.get("recommended_product_ids", [])
                _save_recommendations_to_customer(conn, cid, product_ids)

                summary["updated_customers"] += 1
                summary["items"].append({
                    "customer_id": cid,
                    "recommended_product_ids": product_ids,
                })
            except Exception as e:
                summary["items"].append({
                    "customer_id": cid,
                    "error": str(e),
                })

        conn.commit()

    return summary


# -----------------------------
# Scheduler control
# -----------------------------
def _scheduler_loop():
    global _scheduler_running

    try:
        # immediate first run
        run_recommendations_for_all_customers(
            neighbor_limit=_scheduler_neighbor_limit,
            product_limit=_scheduler_product_limit,
        )

        while not _scheduler_stop_event.wait(_scheduler_refresh_seconds):
            run_recommendations_for_all_customers(
                neighbor_limit=_scheduler_neighbor_limit,
                product_limit=_scheduler_product_limit,
            )
    finally:
        with _scheduler_lock:
            _scheduler_running = False

def start_scheduler(
    neighbor_limit: int = 3,
    product_limit: int = 3,
    refresh_seconds: int = REFRESH_SECONDS,
):
    global _scheduler_thread, _scheduler_running
    global _scheduler_neighbor_limit, _scheduler_product_limit, _scheduler_refresh_seconds

    with _scheduler_lock:
        _scheduler_neighbor_limit = neighbor_limit
        _scheduler_product_limit = product_limit
        _scheduler_refresh_seconds = refresh_seconds

        if _scheduler_running:
            return {
                "started": False,
                "running": True,
                "neighbor_limit": _scheduler_neighbor_limit,
                "product_limit": _scheduler_product_limit,
                "refresh_seconds": _scheduler_refresh_seconds,
            }

        _scheduler_stop_event.clear()
        _scheduler_thread = threading.Thread(target=_scheduler_loop, daemon=True)
        _scheduler_thread.start()
        _scheduler_running = True

        return {
            "started": True,
            "running": True,
            "neighbor_limit": _scheduler_neighbor_limit,
            "product_limit": _scheduler_product_limit,
            "refresh_seconds": _scheduler_refresh_seconds,
        }


def stop_scheduler():
    global _scheduler_thread, _scheduler_running

    with _scheduler_lock:
        if not _scheduler_running:
            return False

        _scheduler_stop_event.set()
        thread = _scheduler_thread

    if thread and thread.is_alive():
        thread.join(timeout=2)

    with _scheduler_lock:
        _scheduler_thread = None
        _scheduler_running = False

    return True

def ensure_scheduler_started():
    global _scheduler_thread, _scheduler_running

    with _scheduler_lock:
        if _scheduler_running:
            return False

        _scheduler_stop_event.clear()
        _scheduler_thread = threading.Thread(target=_scheduler_loop, daemon=True)
        _scheduler_thread.start()
        _scheduler_running = True
        return True


def stop_scheduler():
    global _scheduler_thread, _scheduler_running

    with _scheduler_lock:
        if not _scheduler_running:
            return False

        _scheduler_stop_event.set()
        thread = _scheduler_thread

    if thread and thread.is_alive():
        thread.join(timeout=2)

    with _scheduler_lock:
        _scheduler_thread = None
        _scheduler_running = False

    return True


# -----------------------------
# API
# -----------------------------
@app.get("/health")
def health():
    return {"status": "ok"}


@app.get("/recommend/trigger/status")
def trigger_status():
    return {
        "running": _scheduler_running,
        "neighbor_limit": _scheduler_neighbor_limit,
        "product_limit": _scheduler_product_limit,
        "refresh_seconds": _scheduler_refresh_seconds,
    }


@app.post("/recommend/trigger/stop")
def trigger_stop():
    stopped = stop_scheduler()
    return {
        "ok": True,
        "stopped": stopped,
        "running": _scheduler_running,
    }


@app.post("/recommend/run-all")
def recommend_run_all():
    result = run_recommendations_for_all_customers()
    return result


@app.get("/profiles/by-age", response_model=ProfilesResponse)
def profiles_by_age(
    entity: Literal["customer", "seller"] = Query("customer"),
    min_age: int = Query(18, ge=0, le=120),
    max_age: int = Query(35, ge=0, le=120),
    limit: int = Query(50, ge=1, le=200),
    offset: int = Query(0, ge=0),
):
    if min_age > max_age:
        raise HTTPException(status_code=400, detail="min_age must be <= max_age")

    p = _require_pool()

    if entity == "customer":
        sql = """
        SELECT
          'customer'::text AS entity,
          id,
          EXTRACT(YEAR FROM age(date_of_birth))::int AS age,
          date_of_birth::text AS date_of_birth,
          first_name,
          last_name,
          email,
          job,
          interests
        FROM public.customer
        WHERE date_of_birth IS NOT NULL
          AND deleted_at IS NULL
          AND EXTRACT(YEAR FROM age(date_of_birth))::int BETWEEN %s AND %s
        ORDER BY age ASC, id ASC
        LIMIT %s OFFSET %s
        """
    else:
        sql = """
        SELECT
          'seller'::text AS entity,
          id,
          EXTRACT(YEAR FROM age(date_of_birth))::int AS age,
          date_of_birth::text AS date_of_birth,
          name,
          handle,
          email,
          job,
          interests
        FROM public.seller
        WHERE date_of_birth IS NOT NULL
          AND deleted_at IS NULL
          AND EXTRACT(YEAR FROM age(date_of_birth))::int BETWEEN %s AND %s
        ORDER BY age ASC, id ASC
        LIMIT %s OFFSET %s
        """

    with p.connection() as conn:
        with conn.cursor(row_factory=dict_row) as cur:
            cur.execute(sql, (min_age, max_age, limit, offset))
            rows: List[Dict[str, Any]] = cur.fetchall()

    items: List[ProfileItem] = []
    for r in rows:
        if r.get("age") is None:
            continue
        items.append(ProfileItem(**r))

    return ProfilesResponse(
        entity=entity,
        min_age=min_age,
        max_age=max_age,
        limit=limit,
        offset=offset,
        count=len(items),
        items=items,
    )


@app.get("/recommend/trigger/start")
def trigger_start(
    neighbor_limit: int = Query(3, ge=1, le=10),
    product_limit: int = Query(3, ge=1, le=10),
    refresh_seconds: int = Query(86400, ge=10),
):
    result = start_scheduler(
        neighbor_limit=neighbor_limit,
        product_limit=product_limit,
        refresh_seconds=refresh_seconds,
    )
    return {
        "ok": True,
        **result,
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=9400)