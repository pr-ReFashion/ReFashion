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

    const query = `
      SELECT co2_saved_kg, landfill_reduced_kg, water_saved_liters
      FROM customer
      WHERE email = $1
    `
    const result = await pool.query(query, [email])

    const row = result.rows[0] ?? {
      co2_saved_kg: 0,
      landfill_reduced_kg: 0,
      water_saved_liters: 0,
    }

    return res.json(row)
  } catch (e: any) {
    console.error("SQL error:", e)
    return res.status(500).json({ message: e?.message || "Server error" })
  }
}
