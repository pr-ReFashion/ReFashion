import { Migration } from '@mikro-orm/migrations';

export class Migration20250916_AddRewardColumns extends Migration {
  async up(): Promise<void> {
    // CUSTOMER: σύνολο πόντων
    this.addSql(`
      ALTER TABLE public.customer
      ADD COLUMN IF NOT EXISTS total_rewards integer NOT NULL DEFAULT 0;
    `);

    // SELLER: σύνολο πόντων
    this.addSql(`
      ALTER TABLE public.seller
      ADD COLUMN IF NOT EXISTS total_rewards integer NOT NULL DEFAULT 0;
    `);

    this.addSql(`
      ALTER TABLE public.seller
      ADD COLUMN IF NOT EXISTS reward_points integer NOT NULL DEFAULT 0;
    `);

    this.addSql(`
      DO $$
      BEGIN
        IF EXISTS (
          SELECT 1
          FROM information_schema.columns
          WHERE table_schema = 'public'
            AND table_name = 'seller'
            AND column_name = 'reward_points'
        ) THEN
          UPDATE public.seller
             SET total_rewards = COALESCE(total_rewards, 0) + COALESCE(reward_points, 0)
           WHERE COALESCE(reward_points, 0) > 0;
        END IF;
      END
      $$;
    `);

    // ORDER: προσοχή στα quotes
    this.addSql(`
      ALTER TABLE public."order"
        ADD COLUMN IF NOT EXISTS reward_buyer integer NULL,
        ADD COLUMN IF NOT EXISTS reward_seller integer NULL;
    `);

    // ✅ SAFE προσθήκη constraint για CUSTOMER
    this.addSql(`
      DO $$
      BEGIN
        IF NOT EXISTS (
          SELECT 1 FROM pg_constraint WHERE conname = 'customer_total_rewards_nonneg'
        ) THEN
          ALTER TABLE public.customer
            ADD CONSTRAINT customer_total_rewards_nonneg CHECK (total_rewards >= 0);
        END IF;
      END
      $$;
    `);

    // ✅ SAFE προσθήκη constraint για SELLER
    this.addSql(`
      DO $$
      BEGIN
        IF NOT EXISTS (
          SELECT 1 FROM pg_constraint WHERE conname = 'seller_total_rewards_nonneg'
        ) THEN
          ALTER TABLE public.seller
            ADD CONSTRAINT seller_total_rewards_nonneg CHECK (total_rewards >= 0);
        END IF;
      END
      $$;
    `);
  }

  async down(): Promise<void> {
    this.addSql(`ALTER TABLE public."order" DROP COLUMN IF EXISTS reward_buyer;`);
    this.addSql(`ALTER TABLE public."order" DROP COLUMN IF EXISTS reward_seller;`);

    this.addSql(`ALTER TABLE public.customer DROP CONSTRAINT IF EXISTS customer_total_rewards_nonneg;`);
    this.addSql(`ALTER TABLE public.seller   DROP CONSTRAINT IF EXISTS seller_total_rewards_nonneg;`);

    this.addSql(`ALTER TABLE public.customer DROP COLUMN IF EXISTS total_rewards;`);
    this.addSql(`ALTER TABLE public.seller   DROP COLUMN IF EXISTS total_rewards;`);
  }
}
