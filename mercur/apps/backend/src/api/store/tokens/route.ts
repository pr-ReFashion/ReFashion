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
      select c.total_rewards 
      from customer c 
      where c.email = $1
    `

    const result = await pool.query(query, [email])

    
    const totalRewards = result.rows[0]?.total_rewards ?? 0

    return res.json({ totalRewards })
  } catch (e: any) {
    console.error("SQL error:", e)
    return res.status(500).json({ message: e?.message || "Server error" })
  }
}
