import { Migration } from "@mikro-orm/migrations"

export class Migration20260211_CreateRftRewardLedger extends Migration {
  async up(): Promise<void> {
    this.addSql(`
      CREATE TABLE IF NOT EXISTS public.rft_reward_ledger (
        id text NOT NULL,

        customer_id text NOT NULL,

        role text NOT NULL,
        event_type text NOT NULL,
        event_id text NOT NULL,
        reward_event_id text NOT NULL,

        amount_rft integer NOT NULL,
        value_euro numeric(14, 2) NOT NULL DEFAULT 0,

        direction text NOT NULL,
        status text NOT NULL,

        tx_hash text NULL,
        block_number integer NULL,

        year integer NOT NULL,

        metadata jsonb NOT NULL DEFAULT '{}'::jsonb,

        created_at timestamptz NOT NULL DEFAULT now(),
        updated_at timestamptz NOT NULL DEFAULT now(),

        CONSTRAINT rft_reward_ledger_pkey PRIMARY KEY (id),

        CONSTRAINT rft_reward_ledger_role_check
          CHECK (role IN ('buyer', 'seller', 'user')),

        CONSTRAINT rft_reward_ledger_event_type_check
          CHECK (
            event_type IN (
              'PROFILE_VERIFIED',
              'FIRST_LISTING_APPROVED',
              'LISTING_APPROVED',
              'ORDER_COMPLETED_BUYER',
              'ORDER_COMPLETED_SELLER',
              'CO2_MILESTONE',
              'REDEMPTION'
            )
          ),

        CONSTRAINT rft_reward_ledger_amount_non_negative
          CHECK (amount_rft >= 0),

        CONSTRAINT rft_reward_ledger_value_euro_non_negative
          CHECK (value_euro >= 0),

        CONSTRAINT rft_reward_ledger_direction_check
          CHECK (direction IN ('ISSUE', 'DEDUCT')),

        CONSTRAINT rft_reward_ledger_status_check
          CHECK (status IN ('ISSUED', 'DEDUCTED')),

        CONSTRAINT rft_reward_ledger_block_number_non_negative
          CHECK (block_number IS NULL OR block_number >= 0),

        CONSTRAINT rft_reward_ledger_year_valid
          CHECK (year >= 2020)
      );
    `)

    this.addSql(`
      CREATE UNIQUE INDEX IF NOT EXISTS IDX_rft_reward_ledger_reward_event_id_unique
      ON public.rft_reward_ledger (reward_event_id);
    `)

    this.addSql(`
      CREATE INDEX IF NOT EXISTS IDX_rft_reward_ledger_customer_id
      ON public.rft_reward_ledger (customer_id);
    `)

    this.addSql(`
      CREATE INDEX IF NOT EXISTS IDX_rft_reward_ledger_customer_year
      ON public.rft_reward_ledger (customer_id, year);
    `)

    this.addSql(`
      CREATE INDEX IF NOT EXISTS IDX_rft_reward_ledger_event_type
      ON public.rft_reward_ledger (event_type);
    `)

    this.addSql(`
      CREATE INDEX IF NOT EXISTS IDX_rft_reward_ledger_event_id
      ON public.rft_reward_ledger (event_id);
    `)

    this.addSql(`
      CREATE INDEX IF NOT EXISTS IDX_rft_reward_ledger_direction
      ON public.rft_reward_ledger (direction);
    `)

    this.addSql(`
      CREATE INDEX IF NOT EXISTS IDX_rft_reward_ledger_status
      ON public.rft_reward_ledger (status);
    `)

    this.addSql(`
      CREATE INDEX IF NOT EXISTS IDX_rft_reward_ledger_created_at
      ON public.rft_reward_ledger (created_at);
    `)

    this.addSql(`
      CREATE INDEX IF NOT EXISTS IDX_rft_reward_ledger_metadata_gin
      ON public.rft_reward_ledger USING gin (metadata);
    `)
  }

  async down(): Promise<void> {
    this.addSql(`
      DROP INDEX IF EXISTS public."IDX_rft_reward_ledger_metadata_gin";
    `)

    this.addSql(`
      DROP INDEX IF EXISTS public."IDX_rft_reward_ledger_created_at";
    `)

    this.addSql(`
      DROP INDEX IF EXISTS public."IDX_rft_reward_ledger_status";
    `)

    this.addSql(`
      DROP INDEX IF EXISTS public."IDX_rft_reward_ledger_direction";
    `)

    this.addSql(`
      DROP INDEX IF EXISTS public."IDX_rft_reward_ledger_event_id";
    `)

    this.addSql(`
      DROP INDEX IF EXISTS public."IDX_rft_reward_ledger_event_type";
    `)

    this.addSql(`
      DROP INDEX IF EXISTS public."IDX_rft_reward_ledger_customer_year";
    `)

    this.addSql(`
      DROP INDEX IF EXISTS public."IDX_rft_reward_ledger_customer_id";
    `)

    this.addSql(`
      DROP INDEX IF EXISTS public."IDX_rft_reward_ledger_reward_event_id_unique";
    `)

    this.addSql(`
      DROP TABLE IF EXISTS public.rft_reward_ledger;
    `)
  }
}