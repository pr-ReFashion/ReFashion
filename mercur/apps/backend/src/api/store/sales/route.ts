"use server"

import type { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"
import { Pool } from "pg"

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
})

export const GET = async (req: MedusaRequest, res: MedusaResponse) => {
  try {
    let email = req.query?.email as string

    if (!email) {
      return res.status(400).json({ message: "Missing email parameter" })
    }

    // Normalize email to match database
    if (!email.endsWith(".refashion")) {
      email = `${email}.refashion`
    }

    const query = `
      SELECT COUNT(DISTINCT o.id) AS completed_order_count
      FROM "order" o
      WHERE o.id IN (
        SELECT ssoo.order_id
        FROM seller s
        JOIN seller_seller_order_order ssoo
          ON ssoo.seller_id = s.id
        WHERE s.email = $1
      )
      AND o.status = 'completed';
    `

    const result = await pool.query(query, [email])
    const count = Number(result.rows[0].completed_order_count || 0)

    return res.json({ count })
  } catch (e: any) {
    console.error("SQL error:", e)
    return res.status(500).json({ message: e?.message || "Server error" })
  }
}
