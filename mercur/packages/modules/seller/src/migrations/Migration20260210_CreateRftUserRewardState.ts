import { Migration } from "@mikro-orm/migrations"

export class Migration20260210_CreateRftUserRewardState extends Migration {
  async up(): Promise<void> {
    this.addSql(`
      CREATE TABLE IF NOT EXISTS public.rft_user_reward_state (
        id text NOT NULL,
        customer_id text NOT NULL,

        wallet_created boolean NOT NULL DEFAULT false,
        wallet_address text NULL,

        profile_reward_issued boolean NOT NULL DEFAULT false,

        approved_listings_this_year integer NOT NULL DEFAULT 0,
        has_first_approved_listing boolean NOT NULL DEFAULT false,

        total_rft_issued_this_year integer NOT NULL DEFAULT 0,
        buyer_rft_issued_this_year integer NOT NULL DEFAULT 0,
        seller_rft_issued_this_year integer NOT NULL DEFAULT 0,
        in_app_rft_issued_this_year integer NOT NULL DEFAULT 0,

        total_co2_avoided_this_year_kg numeric(14, 4) NOT NULL DEFAULT 0,
        co2_milestones_rewarded_this_year integer NOT NULL DEFAULT 0,

        rft_redeemed_this_year integer NOT NULL DEFAULT 0,
        rft_balance_cached integer NULL,

        rewards_enabled boolean NOT NULL DEFAULT true,
        rewards_disabled_reason text NULL,

        year integer NOT NULL,

        created_at timestamptz NOT NULL DEFAULT now(),
        updated_at timestamptz NOT NULL DEFAULT now(),

        CONSTRAINT rft_user_reward_state_pkey PRIMARY KEY (id),

        CONSTRAINT rft_user_reward_state_approved_listings_non_negative
          CHECK (approved_listings_this_year >= 0),

        CONSTRAINT rft_user_reward_state_total_issued_non_negative
          CHECK (total_rft_issued_this_year >= 0),

        CONSTRAINT rft_user_reward_state_buyer_issued_non_negative
          CHECK (buyer_rft_issued_this_year >= 0),

        CONSTRAINT rft_user_reward_state_seller_issued_non_negative
          CHECK (seller_rft_issued_this_year >= 0),

        CONSTRAINT rft_user_reward_state_in_app_issued_non_negative
          CHECK (in_app_rft_issued_this_year >= 0),

        CONSTRAINT rft_user_reward_state_co2_non_negative
          CHECK (total_co2_avoided_this_year_kg >= 0),

        CONSTRAINT rft_user_reward_state_co2_milestones_range
          CHECK (co2_milestones_rewarded_this_year >= 0 AND co2_milestones_rewarded_this_year <= 5),

        CONSTRAINT rft_user_reward_state_redeemed_non_negative
          CHECK (rft_redeemed_this_year >= 0),

        CONSTRAINT rft_user_reward_state_balance_cached_non_negative
          CHECK (rft_balance_cached IS NULL OR rft_balance_cached >= 0),

        CONSTRAINT rft_user_reward_state_year_valid
          CHECK (year >= 2020)
      );
    `)

    this.addSql(`
      CREATE UNIQUE INDEX IF NOT EXISTS IDX_rft_user_reward_state_customer_year_unique
      ON public.rft_user_reward_state (customer_id, year);
    `)

    this.addSql(`
      CREATE INDEX IF NOT EXISTS IDX_rft_user_reward_state_customer_id
      ON public.rft_user_reward_state (customer_id);
    `)

    this.addSql(`
      CREATE INDEX IF NOT EXISTS IDX_rft_user_reward_state_year
      ON public.rft_user_reward_state (year);
    `)

    this.addSql(`
      CREATE INDEX IF NOT EXISTS IDX_rft_user_reward_state_rewards_enabled
      ON public.rft_user_reward_state (rewards_enabled);
    `)
  }

  async down(): Promise<void> {
    this.addSql(`
      DROP INDEX IF EXISTS public."IDX_rft_user_reward_state_rewards_enabled";
    `)

    this.addSql(`
      DROP INDEX IF EXISTS public."IDX_rft_user_reward_state_year";
    `)

    this.addSql(`
      DROP INDEX IF EXISTS public."IDX_rft_user_reward_state_customer_id";
    `)

    this.addSql(`
      DROP INDEX IF EXISTS public."IDX_rft_user_reward_state_customer_year_unique";
    `)

    this.addSql(`
      DROP TABLE IF EXISTS public.rft_user_reward_state;
    `)
  }
}