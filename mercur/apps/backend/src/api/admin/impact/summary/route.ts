// GET /admin/impact/summary
// Returns totals for the 3 sustainability fields from public.customer

import type { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"
import { Pool } from "pg"

// Reuse a single pool (works in dev hot-reload too)
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
})

export const GET = async (_req: MedusaRequest, res: MedusaResponse) => {
  try {
    const { rows } = await pool.query(`
      SELECT
        COALESCE(SUM(co2_saved_kg), 0)::numeric(12,2)        AS co2_saved_kg_total,
        COALESCE(SUM(water_saved_liters), 0)::numeric(12,2)  AS water_saved_liters_total,
        COALESCE(SUM(landfill_reduced_kg), 0)::numeric(12,2) AS landfill_reduced_kg_total
      FROM public.customer
      WHERE deleted_at IS NULL
    `)

    const out =
      rows[0] ?? {
        co2_saved_kg_total: "0.00",
        water_saved_liters_total: "0.00",
        landfill_reduced_kg_total: "0.00",
      }

    return res.json(out)
  } catch (e: any) {
    return res.status(500).json({ message: e?.message ?? "Failed to fetch totals" })
  }
}
