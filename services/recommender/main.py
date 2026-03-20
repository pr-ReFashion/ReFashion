import os
from fastapi.encoders import jsonable_encoder
from typing import Literal, Optional, List, Dict, Any
import json
from fastapi.responses import Response
from fastapi import FastAPI, Query, HTTPException
from pydantic import BaseModel
from pathlib import Path
import datetime as dt
from psycopg.rows import dict_row
from psycopg_pool import ConnectionPool

OUTPUT_DIR = Path(__file__).resolve().parent / "outputs"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

def _write_output_json(prefix: str, payload: Any) -> str:
    ts = dt.datetime.utcnow().strftime("%Y%m%d_%H%M%S_%f")
    out_path = OUTPUT_DIR / f"{prefix}_{ts}.json"

    safe_payload = jsonable_encoder(payload)  # <-- converts BaseModel, datetime, etc.

    text = json.dumps(
        safe_payload,
        ensure_ascii=False,
        indent=4,
        separators=(",", ":  "),
    ) + "\n"

    out_path.write_text(text, encoding="utf-8")
    return str(out_path)

# ---- Config ----
DATABASE_URL = os.getenv("DATABASE_URL", "postgres://postgres:postgres@localhost:5432/mercur_db").strip()
if not DATABASE_URL:
    # allow PG* envs as fallback
    # (still recommend DATABASE_URL)
    pass

app = FastAPI(title="Recommender Service", version="0.1.0")

pool: Optional[ConnectionPool] = None


@app.on_event("startup")
def _startup():
    global pool
    if not DATABASE_URL:
        raise RuntimeError("DATABASE_URL is required")
    pool = ConnectionPool(conninfo=DATABASE_URL, min_size=1, max_size=5, open=True)


@app.on_event("shutdown")
def _shutdown():
    global pool
    if pool:
        pool.close()
        pool = None


@app.get("/health")
def health():
    return {"status": "ok"}


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
    # customer fields
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    email: Optional[str] = None
    # seller fields
    name: Optional[str] = None
    handle: Optional[str] = None
    # shared optional
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


def _require_pool() -> ConnectionPool:
    if not pool:
        raise RuntimeError("DB pool not initialized")
    return pool


@app.get("/recommend/closest-products", response_model=RecommendationResponse)
def recommend_closest_products(
    customer_id: str = Query(...),
    neighbor_limit: int = Query(3, ge=1, le=10),
    product_limit: int = Query(3, ge=1, le=10),
):
    p = _require_pool()

    with p.connection() as conn:
        with conn.cursor(row_factory=dict_row) as cur:
            # 1) input customer
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
                raise HTTPException(status_code=404, detail="Input customer not found")

            if not input_customer.get("date_of_birth"):
                raise HTTPException(status_code=400, detail="Input customer has no date_of_birth")

            input_dob = input_customer["date_of_birth"]
            input_age = int(input_customer["age"])

            # 2) closest neighbors by age (using DOB distance in days)
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

            neighbors = [NeighborItem(**row) for row in neighbor_rows]
            neighbor_ids = [row["customer_id"] for row in neighbor_rows]

            if not neighbor_ids:
                payload = RecommendationResponse(
                    input_customer_id=customer_id,
                    input_age=input_age,
                    neighbor_count=0,
                    product_count=0,
                    neighbors=[],
                    neighbor_products=[],
                    recommended_product_ids=[],
                ).model_dump()

                _write_output_json(f"recommend_{customer_id}", payload)
                return payload

            # 3) get all candidate products from neighbors' order history
            #    ordered by neighbor closeness first, then newest order/item
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
                )
                SELECT
                  n.customer_id AS neighbor_customer_id,
                  o.id AS order_id,
                  oi.item_id AS order_line_item_id,
                  oli.product_id,
                  n.neighbor_rank,
                  o.created_at AS order_created_at,
                  oi.created_at AS order_item_created_at
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
                ORDER BY
                  n.neighbor_rank ASC,
                  o.created_at DESC,
                  oi.created_at DESC,
                  oli.product_id ASC
                """,
                (input_dob, customer_id, input_dob, neighbor_limit),
            )
            product_rows = cur.fetchall()

    # 4) one sampled product per close user (latest by order), then unique <= 3
    neighbor_products: List[NeighborProductItem] = []
    seen_neighbor = set()

    for row in product_rows:
        nid = row["neighbor_customer_id"]
        if nid in seen_neighbor:
            continue
        seen_neighbor.add(nid)
        neighbor_products.append(
            NeighborProductItem(
                neighbor_customer_id=nid,
                product_id=row["product_id"],
                order_id=row["order_id"],
                order_line_item_id=row["order_line_item_id"],
            )
        )

    # 5) unique product ids, max product_limit
    recommended_product_ids: List[str] = []
    seen_products = set()

    for np in neighbor_products:
        pid = np.product_id
        if not pid or pid in seen_products:
            continue
        seen_products.add(pid)
        recommended_product_ids.append(pid)
        if len(recommended_product_ids) >= product_limit:
            break

    payload = RecommendationResponse(
        input_customer_id=customer_id,
        input_age=input_age,
        neighbor_count=len(neighbors),
        product_count=len(recommended_product_ids),
        neighbors=neighbors,
        neighbor_products=neighbor_products,
        recommended_product_ids=recommended_product_ids,
    ).model_dump()

    _write_output_json(f"recommend_{customer_id}", payload)
    return payload


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=9400)