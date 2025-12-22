import type { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"
import { Pool } from "pg"

const pool = new Pool({ connectionString: process.env.DATABASE_URL })

/**
 * GET /admin/impact/timeseries?granularity=day|month&from=YYYY-MM-DD&to=YYYY-MM-DD
 * Returns daily/monthly totals + cumulative.
 */
export const GET = async (req: MedusaRequest, res: MedusaResponse) => {
  try {
    const gran = (String(req.query?.granularity || "day").toLowerCase() === "month") ? "month" : "day"

    const to = req.query?.to ? new Date(String(req.query.to)) : new Date()
    const from =
      req.query?.from
        ? new Date(String(req.query.from))
        : new Date(to.getTime() - 90 * 24 * 60 * 60 * 1000) // default last 90 days

    // Ensure tz timestamps
    const params = [from.toISOString(), to.toISOString()]

    const sql = `
      WITH series AS (
        SELECT generate_series(
          date_trunc('${gran}', $1::timestamptz),
          date_trunc('${gran}', $2::timestamptz),
          interval '1 ${gran}'
        ) AS bucket
      ),
      agg AS (
        SELECT
          date_trunc('${gran}', o.created_at) AS bucket,
          COALESCE(SUM(o.co2_saved_kg), 0)        AS co2,
          COALESCE(SUM(o.water_saved_liters), 0)  AS water,
          COALESCE(SUM(o.landfill_reduced_kg), 0) AS landfill
        FROM public."order" o
        WHERE o.deleted_at IS NULL
          AND o.created_at >= $1::timestamptz
          AND o.created_at <= $2::timestamptz
        GROUP BY 1
      )
      SELECT
        s.bucket::date                        AS date,
        COALESCE(a.co2, 0)::numeric(12,2)     AS co2,
        COALESCE(a.water, 0)::numeric(12,2)   AS water,
        COALESCE(a.landfill, 0)::numeric(12,2) AS landfill
      FROM series s
      LEFT JOIN agg a ON a.bucket = s.bucket
      ORDER BY 1;
    `

    const { rows } = await pool.query(sql, params)

    // add cumulative on the fly
    let cCo2 = 0, cWater = 0, cLandfill = 0
    const series = rows.map((r) => {
      const co2 = Number(r.co2 || 0)
      const water = Number(r.water || 0)
      const landfill = Number(r.landfill || 0)
      cCo2 += co2
      cWater += water
      cLandfill += landfill
      return {
        date: r.date,
        co2,
        water,
        landfill,
        co2_cum: Number(cCo2.toFixed(2)),
        water_cum: Number(cWater.toFixed(2)),
        landfill_cum: Number(cLandfill.toFixed(2)),
      }
    })

    return res.json({
      granularity: gran,
      from: from.toISOString(),
      to: to.toISOString(),
      series,
    })
  } catch (e: any) {
    return res.status(500).json({ message: e?.message ?? "Failed to load timeseries" })
  }
}
