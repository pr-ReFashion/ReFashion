import type { SubscriberArgs, SubscriberConfig } from "@medusajs/framework"
import { ContainerRegistrationKeys, MedusaError } from "@medusajs/framework/utils"
import { Pool } from "pg"

let _pool: Pool | null = null
function getPool(): Pool {
  if (!_pool) {
    const cs = process.env.DATABASE_URL
    if (!cs) throw new Error("DATABASE_URL is not set")
    _pool = new Pool({ connectionString: cs })
  }
  return _pool
}

export default async function orderImpactSubscriber({
  event,
  container,
}: SubscriberArgs<{ id: string }>) {
  const logger = container.resolve(ContainerRegistrationKeys.LOGGER)
  const orderId = event?.data?.id
  if (!orderId) {
    logger.warn("[order-impact] Missing order id")
    return
  }

  const pool = getPool()
  const client = await pool.connect()
  try {
    // 1) find the customer for this order
    const r1 = await client.query<{ customer_id: string }>(
      `SELECT customer_id FROM public."order" WHERE id = $1`,
      [orderId]
    )
    const customerId = r1.rows?.[0]?.customer_id
    if (!customerId) {
      logger.warn(`[order-impact] No customer for order ${orderId}`)
      client.release()
      return
    }

    // 2) call impact micro-service (dummy +1s by default)
    const svcUrl = process.env.IMPACT_SVC_URL || "http://127.0.0.1:9200"
    const resp = await fetch(`${svcUrl}/calc-impact`, {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({ order_id: orderId, customer_id: customerId }),
    })
    if (!resp.ok) {
      throw new MedusaError(
        MedusaError.Types.UNEXPECTED_STATE,
        `impact service returned ${resp.status}`
      )
    }
    const payload = await resp.json().catch(() => ({} as any))
    const co2Add = Number(payload?.co2_add ?? 1)
    const waterAdd = Number(payload?.water_add ?? 1)
    const landfillAdd = Number(payload?.landfill_add ?? 1)

    // 3) persist: set per-order values + increment customer totals (transaction)
    await client.query("BEGIN")

    // Store *per-order* impact values
    await client.query(
      `
      UPDATE public."order"
         SET co2_saved_kg        = $1,
             water_saved_liters  = $2,
             landfill_reduced_kg = $3
       WHERE id = $4
      `,
      [co2Add, waterAdd, landfillAdd, orderId]
    )

    // Increment *customer* totals
    await client.query(
      `
      UPDATE public.customer
         SET co2_saved_kg        = co2_saved_kg + $1,
             water_saved_liters  = water_saved_liters + $2,
             landfill_reduced_kg = landfill_reduced_kg + $3
       WHERE id = $4
      `,
      [co2Add, waterAdd, landfillAdd, customerId]
    )

    await client.query("COMMIT")

    logger.info(
      `[order-impact] order ${orderId}: set (co2=${co2Add}kg, water=${waterAdd}lt, landfill=${landfillAdd}kg) and updated customer ${customerId}`
    )
  } catch (e: any) {
    try { await client.query("ROLLBACK") } catch {}
    logger.warn(`[order-impact] failed for order ${orderId}: ${e?.message}`)
  } finally {
    client.release()
  }
}

export const config: SubscriberConfig = {
  event: "order.placed",
}
