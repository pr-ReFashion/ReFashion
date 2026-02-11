"use server"

import type { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"
import { Pool } from "pg"

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
})

export const GET = async (req: MedusaRequest, res: MedusaResponse) => {
  try {
    const email = req.query?.email as string

    if (!email) {
      return res.status(400).json({ message: "Missing email parameter" })
    }

    // Normalize email: trim and lowercase
    const normalizedEmail = email.trim().toLowerCase()

    const query = `
      SELECT COUNT(*) AS order_count
      FROM "order"
      WHERE email = $1;
    `

    const result = await pool.query(query, [normalizedEmail])
    const count = Number(result.rows[0].order_count || 0)

    return res.json({ count })
  } catch (e: any) {
    console.error("SQL error:", e)
    return res.status(500).json({ message: e?.message || "Server error" })
  }
}
