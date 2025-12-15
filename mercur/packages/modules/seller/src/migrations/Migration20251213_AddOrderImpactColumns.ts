import { Migration } from "@mikro-orm/migrations"

export class Migration20251213_AddOrderImpactColumns extends Migration {
  async up(): Promise<void> {
    this.addSql(`
      ALTER TABLE public."order"
        ADD COLUMN IF NOT EXISTS co2_saved_kg        NUMERIC(12,2) NOT NULL DEFAULT 0,
        ADD COLUMN IF NOT EXISTS water_saved_liters  NUMERIC(12,2) NOT NULL DEFAULT 0,
        ADD COLUMN IF NOT EXISTS landfill_reduced_kg NUMERIC(12,2) NOT NULL DEFAULT 0;
    `)

    this.addSql(`CREATE INDEX IF NOT EXISTS idx_order_impact_created_at ON public."order"(created_at)`)
  }

  async down(): Promise<void> {
    this.addSql(`DROP INDEX IF EXISTS idx_order_impact_created_at`)
    this.addSql(`
      ALTER TABLE public."order"
        DROP COLUMN IF EXISTS landfill_reduced_kg,
        DROP COLUMN IF EXISTS water_saved_liters,
        DROP COLUMN IF EXISTS co2_saved_kg;
    `)
  }
}
