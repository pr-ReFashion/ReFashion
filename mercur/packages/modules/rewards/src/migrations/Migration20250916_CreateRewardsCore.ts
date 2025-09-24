import { Migration } from '@mikro-orm/migrations';

export class Migration20250916_CreateRewardsCore extends Migration {
  async up(): Promise<void> {
    // rewards_balance: composite primary key (subject_type, subject_id)
    this.addSql(`
      CREATE TABLE IF NOT EXISTS public.rewards_balance (
        subject_type TEXT NOT NULL,
        subject_id   TEXT NOT NULL,
        reward_points INTEGER NOT NULL DEFAULT 0,
        created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
        updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
        CONSTRAINT rewards_balance_pkey PRIMARY KEY (subject_type, subject_id),
        CONSTRAINT rewards_balance_non_negative CHECK (reward_points >= 0)
      );
    `);

    this.addSql(`
      CREATE INDEX IF NOT EXISTS "IDX_rewards_balance_subject"
        ON public.rewards_balance (subject_type, subject_id);
    `);

    // rewards_ledger: audit trail
    this.addSql(`
      CREATE TABLE IF NOT EXISTS public.rewards_ledger (
        id           BIGSERIAL PRIMARY KEY,
        subject_type TEXT NOT NULL,
        subject_id   TEXT NOT NULL,
        delta        INTEGER NOT NULL,
        reason       TEXT NULL,
        meta         JSONB NULL,
        created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
      );
    `);

    this.addSql(`
      CREATE INDEX IF NOT EXISTS "IDX_rewards_ledger_subject"
        ON public.rewards_ledger (subject_type, subject_id, created_at DESC);
    `);
  }

  async down(): Promise<void> {
    this.addSql(`DROP TABLE IF EXISTS public.rewards_ledger CASCADE;`);
    this.addSql(`DROP TABLE IF EXISTS public.rewards_balance CASCADE;`);
  }
}
