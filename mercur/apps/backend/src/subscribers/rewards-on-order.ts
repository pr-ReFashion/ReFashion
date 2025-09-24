/* eslint-disable @typescript-eslint/no-explicit-any */
import { Pool } from "pg"
import type { SubscriberArgs, SubscriberConfig } from "@medusajs/framework"

export const config: SubscriberConfig = { event: "order.placed" }

type Payload = { id: string }

export default async function rewardsOnOrder(args: SubscriberArgs<Payload> | any) {
  const container = args?.container
  const orderId: string | undefined = args?.event?.data?.id ?? args?.data?.id ?? args?.id
  const force = !!args?.pluginOptions?.force

  const logger = container?.hasRegistration?.("logger") ? container.resolve("logger") : console
  const log = (m: string, extra?: any) =>
    (logger as any)?.info?.(`[rewards] ${m} ${extra ? JSON.stringify(extra) : ""}`)

  if (!orderId) return

  const pool: Pool =
    container?.hasRegistration?.("pg")
      ? container.resolve("pg")
      : new Pool({ connectionString: process.env.DATABASE_URL })

  const RATE      = Number(process.env.REWARDS_EARN_PER_EUR ?? 0.1)   // points per EUR
  const ZERO_CUST = Number(process.env.REWARDS_ZERO_ORDER_CUSTOMER_POINTS ?? 1)
  const ZERO_SELL = Number(process.env.REWARDS_ZERO_ORDER_SELLER_POINTS ?? 1)

  // 1) Order basics + total (minor units) from order_summary
  const { rows: ordRows } = await pool.query(
    `
    SELECT o.id,
           o.customer_id,
           o.reward_buyer,
           o.reward_seller,
           COALESCE((os.totals->>'total')::bigint, 0) AS total_cents
      FROM public."order" o
 LEFT JOIN public.order_summary os ON os.order_id = o.id
     WHERE o.id = $1
    `,
    [orderId]
  )
  const order = ordRows?.[0]
  if (!order) return
  if (!force && order.reward_buyer !== null && order.reward_seller !== null) {
    log("already rewarded → skip", { orderId })
    return
  }

// 2) Discover sellers from line items
const sellerIds = new Set<string>()

try {
  const { rows } = await pool.query(
    `
    WITH lines AS (
      SELECT oli.product_id, oli.variant_id
      FROM public.order_item oi
      JOIN public.order_line_item oli ON oli.id = oi.item_id
      WHERE oi.order_id = $1
    ),
    prods AS (
      SELECT DISTINCT COALESCE(l.product_id, pv.product_id) AS product_id
      FROM lines l
      LEFT JOIN public.product_variant pv ON pv.id = l.variant_id
      WHERE COALESCE(l.product_id, pv.product_id) IS NOT NULL
    )
    SELECT DISTINCT spp.seller_id
    FROM prods p
    JOIN public.seller_seller_product_product spp
      ON spp.product_id = p.product_id
    `,
    [orderId]
  )
  for (const r of rows) if (r.seller_id) sellerIds.add(r.seller_id)
  log("seller discovery", { count: sellerIds.size, sellers: [...sellerIds] })
} catch (e: any) {
  log("seller discovery failed", { err: e?.code || e?.message })
}

  // 3) Points
  const totalCents = Number(order.total_cents || 0)
  let buyerPts = Math.floor((totalCents / 100) * RATE)
  if (buyerPts <= 0) buyerPts = ZERO_CUST

  const sellerCount = sellerIds.size
  const perSellerPts =
    sellerCount <= 1
      ? Math.max(ZERO_SELL, Math.floor((totalCents / 100) * RATE))
      : Math.max(ZERO_SELL, Math.floor(buyerPts / sellerCount))

  // helper to touch balance + ledger
  const award = async (
    subject: "customer" | "seller",
    subjectId: string,
    delta: number,
    reason: string,
    meta: Record<string, unknown>
  ) => {
    await pool.query(
      `INSERT INTO public.rewards_balance (subject_type, subject_id, reward_points)
       VALUES ($1,$2,0)
       ON CONFLICT (subject_type, subject_id) DO NOTHING`,
      [subject, subjectId]
    )
    await pool.query(
      `UPDATE public.rewards_balance
          SET reward_points = GREATEST(0, reward_points + $3),
              updated_at    = NOW()
        WHERE subject_type = $1 AND subject_id = $2`,
      [subject, subjectId, Number(delta)]
    )
    await pool.query(
      `INSERT INTO public.rewards_ledger
         (subject_type, subject_id, delta, reason, meta, created_at)
       VALUES ($1,$2,$3,$4,$5,NOW())`,
      [subject, subjectId, Number(delta), reason, meta ?? { order_id: orderId }]
    )
  }

  // 4) Writes (idempotent; honor ?force=true)
  await pool.query("BEGIN")
  try {
    if (force || order.reward_buyer == null) {
      if (order.customer_id && buyerPts) {
        await award("customer", order.customer_id, buyerPts, "order.placed", { order_id: orderId })
        await pool.query(
          `UPDATE public.customer
              SET total_rewards = COALESCE(total_rewards, 0) + $2
            WHERE id = $1`,
          [order.customer_id, buyerPts]
        )
      }
      await pool.query(`UPDATE public."order" SET reward_buyer = $2 WHERE id = $1`, [orderId, buyerPts || null])
    }

    if (force || order.reward_seller == null) {
      let sellersSum = 0
      for (const sid of sellerIds) {
        sellersSum += perSellerPts
        await award("seller", sid, perSellerPts, "order.placed", { order_id: orderId })
        await pool.query(
          `UPDATE public.seller
              SET total_rewards = COALESCE(total_rewards, 0) + $2,
                  reward_points = COALESCE(reward_points, 0) + $2
            WHERE id = $1`,
          [sid, perSellerPts]
        )
      }
      await pool.query(`UPDATE public."order" SET reward_seller = $2 WHERE id = $1`, [
        orderId,
        sellerIds.size ? sellersSum : null,
      ])
    }

    await pool.query("COMMIT")
    log("done", { orderId, buyerPts, sellerCount, perSellerPts })
  } catch (e: any) {
    await pool.query("ROLLBACK")
    log("rollback", { orderId, error: e?.message })
  }
}
