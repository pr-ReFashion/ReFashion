import { Pool } from "pg"

type Subject = "customer" | "seller"

export default class RewardsModuleService {
  private static _pool: Pool | null = null
  private pool: Pool

  constructor() {
    if (!RewardsModuleService._pool) {
      const cs = process.env.DATABASE_URL
      if (!cs) {
        throw new Error("RewardsModuleService: DATABASE_URL is not set")
      }
      RewardsModuleService._pool = new Pool({ connectionString: cs })
    }
    this.pool = RewardsModuleService._pool!
  }

  async getBalance(subject: Subject, subjectId: string): Promise<number> {
    const { rows } = await this.pool.query(
      `SELECT reward_points
         FROM public.rewards_balance
        WHERE subject_type = $1 AND subject_id = $2
        LIMIT 1`,
      [subject, subjectId]
    )
    return Number(rows?.[0]?.reward_points ?? 0)
  }

  async increment(
    subject: Subject,
    subjectId: string,
    delta: number,
    reason?: string,
    meta?: Record<string, unknown>
  ): Promise<number> {
    await this.pool.query(
      `INSERT INTO public.rewards_balance (subject_type, subject_id, reward_points)
       VALUES ($1, $2, 0)
       ON CONFLICT (subject_type, subject_id) DO NOTHING`,
      [subject, subjectId]
    )

    const { rows } = await this.pool.query(
      `UPDATE public.rewards_balance
          SET reward_points = GREATEST(0, reward_points + $3),
              updated_at = NOW()
        WHERE subject_type = $1 AND subject_id = $2
      RETURNING reward_points`,
      [subject, subjectId, Number(delta)]
    )
    const newBalance = Number(rows?.[0]?.reward_points ?? 0)

    await this.pool.query(
      `INSERT INTO public.rewards_ledger
       (subject_type, subject_id, delta, reason, meta, created_at)
       VALUES ($1, $2, $3, $4, $5, NOW())`,
      [subject, subjectId, Number(delta), reason ?? null, meta ?? null]
    )

    return newBalance
  }

  async listLedger(
    subject: Subject,
    subjectId: string,
    opts?: { limit?: number; offset?: number }
  ) {
    const limit = Math.min(Math.max(opts?.limit ?? 20, 1), 100)
    const offset = Math.max(opts?.offset ?? 0, 0)
    const { rows } = await this.pool.query(
      `SELECT id, delta, reason, meta, created_at
         FROM public.rewards_ledger
        WHERE subject_type = $1 AND subject_id = $2
        ORDER BY created_at DESC
        LIMIT $3 OFFSET $4`,
      [subject, subjectId, limit, offset]
    )
    return rows
  }
}
