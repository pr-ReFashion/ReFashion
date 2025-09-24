import { Pool } from "pg"
import type { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"

export const AUTHENTICATE = false // dev only

type Body = { order_id?: string; display_id?: number }

// policy: 1 token / 10€
const RATE = Number(process.env.REWARDS_EARN_PER_EUR || 0.1)

/**
 * Helper: tries to compute order total (in cents) from order_line_item rows,
 * without assuming specific column names.
 */
async function computeOrderTotalCents(pool: Pool, orderId: string): Promise<number> {
  // Πάρε όλα τα columns των line items, και μετά κάνε robust υπολογισμό στη JS.
  const { rows: items } = await pool.query(
    `SELECT * FROM public.order_line_item WHERE order_id = $1`,
    [orderId]
  )

  let sum = 0
  for (const li of items) {
    // Προτεραιότητες: total -> amount -> raw_total -> subtotal
    // αλλιώς unit_price * quantity (αν υπάρχουν)
    const val =
      (typeof li.total === "number" && li.total) ||
      (typeof li.amount === "number" && li.amount) ||
      (typeof li.raw_total === "number" && li.raw_total) ||
      (typeof li.subtotal === "number" && li.subtotal) ||
      ((typeof li.unit_price === "number" && typeof li.quantity === "number")
        ? li.unit_price * li.quantity
        : 0)

    sum += Number(val || 0)
  }
  return sum
}

export const POST = async (req: MedusaRequest, res: MedusaResponse) => {
  try {
    const raw =
      typeof (req as any).json === "function"
        ? await (req as any).json()
        : ((req as any).body ?? {})

    const { order_id, display_id } = (raw || {}) as Body
    if (!order_id && !display_id) {
      return res.status(400).json({ message: "order_id or display_id required" })
    }

    const rewards = req.scope.resolve("rewardsModuleService") as any
    const pool = new Pool({ connectionString: process.env.DATABASE_URL })

    // 1) Βρες την order (με id ή display_id)
    const ordQuery =
      order_id
        ? { text: `SELECT * FROM public."order" WHERE id = $1`, values: [order_id] }
        : { text: `SELECT * FROM public."order" WHERE display_id = $1`, values: [display_id] }

    const { rows: ordRows } = await pool.query(ordQuery.text, ordQuery.values)
    const order = ordRows?.[0]
    if (!order) return res.status(404).json({ message: "Order not found" })

    // Idempotency: αν έχει ήδη συμπληρωθεί reward_buyer, σταμάτα
    if (order.reward_buyer !== null && order.reward_buyer !== undefined) {
      return res.json({ message: "Already processed", order_id: order.id })
    }

    // 2) Υπολόγισε σύνολο από line items (σε cents)
    const totalCents = await computeOrderTotalCents(pool, order.id)
    const buyerPoints = Math.floor((totalCents / 100) * RATE)

    // 3) Award buyer + γράψε order fields
    await pool.query("BEGIN")
    try {
      if (order.customer_id && buyerPoints > 0) {
        await rewards.increment("customer", order.customer_id, buyerPoints, "order.paid", { order_id: order.id })
        await pool.query(
          `UPDATE public.customer SET total_rewards = total_rewards + $2 WHERE id = $1`,
          [order.customer_id, buyerPoints]
        )
      }

      await pool.query(
        `UPDATE public."order"
            SET reward_buyer = $2
          WHERE id = $1`,
        [order.id, buyerPoints || null]
      )

      await pool.query("COMMIT")
    } catch (e) {
      await pool.query("ROLLBACK")
      throw e
    }

    return res.json({
      ok: true,
      order_id: order.id,
      reward_buyer: buyerPoints
      // seller rewarding θα το προσθέσουμε μόλις “κλειδώσουμε” τον χάρτη item→seller
    })
  } catch (err: any) {
    console.error(err)
    return res.status(500).json({ code: "unknown_error", message: "An unknown error occurred." })
  }
}
