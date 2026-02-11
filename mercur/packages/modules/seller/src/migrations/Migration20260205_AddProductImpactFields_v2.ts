import { Migration } from "@mikro-orm/migrations"

export class Migration20260208_ProductImpactPartnerSchema extends Migration {
  async up(): Promise<void> {
    // 1) CLEANUP: drop any wrong/old columns safely (no traces, no errors if missing)
    this.addSql(`
      ALTER TABLE public.product
        DROP COLUMN IF EXISTS impact_version,
        DROP COLUMN IF EXISTS impact_unit,
        DROP COLUMN IF EXISTS impact_user_facing,
        DROP COLUMN IF EXISTS impact_proxy_quantities,
        DROP COLUMN IF EXISTS impact_provenance_lite,
        DROP COLUMN IF EXISTS impact_tshirt_chain,
        DROP COLUMN IF EXISTS impact_assumptions,
        DROP COLUMN IF EXISTS impact_input,
        DROP COLUMN IF EXISTS impact_output,
        DROP COLUMN IF EXISTS impact_payload,
        DROP COLUMN IF EXISTS proxy_quantity,
        DROP COLUMN IF EXISTS proxy_quantity_kwh,
        DROP COLUMN IF EXISTS proxy_quantity_mj,
        DROP COLUMN IF EXISTS proxy_quantity_m3,
        DROP COLUMN IF EXISTS proxy_quantity_tkm;
    `)

    // 2) ADD EXACT partner schema columns
    this.addSql(`
      ALTER TABLE public.product
        -- INPUT (partners)
        ADD COLUMN IF NOT EXISTS tshirt_chain     JSONB NOT NULL DEFAULT '{}'::jsonb,
        ADD COLUMN IF NOT EXISTS assumptions      JSONB NOT NULL DEFAULT '{}'::jsonb,

        -- OUTPUT (partners)
        ADD COLUMN IF NOT EXISTS version          TEXT,
        ADD COLUMN IF NOT EXISTS unit             TEXT,
        ADD COLUMN IF NOT EXISTS user_facing      JSONB NOT NULL DEFAULT '{}'::jsonb,
        ADD COLUMN IF NOT EXISTS proxy_quantities JSONB NOT NULL DEFAULT '{}'::jsonb,
        ADD COLUMN IF NOT EXISTS provenance_lite  JSONB NOT NULL DEFAULT '{}'::jsonb;
    `)

    // optional helpful indexes (safe)
    this.addSql(`CREATE INDEX IF NOT EXISTS idx_product_tshirt_chain_gin     ON public.product USING GIN (tshirt_chain);`)
    this.addSql(`CREATE INDEX IF NOT EXISTS idx_product_assumptions_gin      ON public.product USING GIN (assumptions);`)
    this.addSql(`CREATE INDEX IF NOT EXISTS idx_product_user_facing_gin      ON public.product USING GIN (user_facing);`)
    this.addSql(`CREATE INDEX IF NOT EXISTS idx_product_proxy_quantities_gin ON public.product USING GIN (proxy_quantities);`)
    this.addSql(`CREATE INDEX IF NOT EXISTS idx_product_provenance_lite_gin  ON public.product USING GIN (provenance_lite);`)
  }

  async down(): Promise<void> {
    // Down: remove only the “correct” schema we added
    this.addSql(`DROP INDEX IF EXISTS idx_product_provenance_lite_gin;`)
    this.addSql(`DROP INDEX IF EXISTS idx_product_proxy_quantities_gin;`)
    this.addSql(`DROP INDEX IF EXISTS idx_product_user_facing_gin;`)
    this.addSql(`DROP INDEX IF EXISTS idx_product_assumptions_gin;`)
    this.addSql(`DROP INDEX IF EXISTS idx_product_tshirt_chain_gin;`)

    this.addSql(`
      ALTER TABLE public.product
        DROP COLUMN IF EXISTS provenance_lite,
        DROP COLUMN IF EXISTS proxy_quantities,
        DROP COLUMN IF EXISTS user_facing,
        DROP COLUMN IF EXISTS unit,
        DROP COLUMN IF EXISTS version,
        DROP COLUMN IF EXISTS assumptions,
        DROP COLUMN IF EXISTS tshirt_chain;
    `)
  }
}
