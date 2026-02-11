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
      SELECT COUNT(sspp.product_id) AS product_count
      FROM customer c
      LEFT JOIN seller s 
          ON s.email = c.email || '.refashion'
      LEFT JOIN seller_seller_product_product sspp
          ON sspp.seller_id = s.id
      WHERE c.email = $1
    `

    const result = await pool.query(query, [email])
    const count = Number(result.rows?.[0]?.product_count || 0)

    return res.json({ count })
  } catch (e: any) {
    console.error("SQL error:", e)
    return res.status(500).json({ message: e?.message || "Server error" })
  }
}
