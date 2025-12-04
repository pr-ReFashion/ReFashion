import { Migration } from '@mikro-orm/migrations';

export class Migration20251116_AddCustomerSustainabilityFields extends Migration {
  async up(): Promise<void> {
    // Προσθήκη πεδίων στον customer
    this.addSql(`
      ALTER TABLE public.customer
        ADD COLUMN IF NOT EXISTS co2_saved_kg        NUMERIC(12,2) NOT NULL DEFAULT 0,
        ADD COLUMN IF NOT EXISTS water_saved_liters  NUMERIC(12,2) NOT NULL DEFAULT 0,
        ADD COLUMN IF NOT EXISTS landfill_reduced_kg NUMERIC(12,2) NOT NULL DEFAULT 0;
    `);

    // Ασφαλής προσθήκη CHECK constraints (μη αρνητικές τιμές)
    this.addSql(`
      DO $$
      BEGIN
        IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'customer_co2_saved_nonneg') THEN
          ALTER TABLE public.customer
            ADD CONSTRAINT customer_co2_saved_nonneg CHECK (co2_saved_kg >= 0);
        END IF;

        IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'customer_water_saved_nonneg') THEN
          ALTER TABLE public.customer
            ADD CONSTRAINT customer_water_saved_nonneg CHECK (water_saved_liters >= 0);
        END IF;

        IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'customer_landfill_reduced_nonneg') THEN
          ALTER TABLE public.customer
            ADD CONSTRAINT customer_landfill_reduced_nonneg CHECK (landfill_reduced_kg >= 0);
        END IF;
      END
      $$;
    `);

    // Προαιρετικά indexes για γρήγορα aggregates/φίλτρα
    this.addSql(`CREATE INDEX IF NOT EXISTS idx_customer_sust_co2      ON public.customer (co2_saved_kg);`);
    this.addSql(`CREATE INDEX IF NOT EXISTS idx_customer_sust_water    ON public.customer (water_saved_liters);`);
    this.addSql(`CREATE INDEX IF NOT EXISTS idx_customer_sust_landfill ON public.customer (landfill_reduced_kg);`);
  }

  async down(): Promise<void> {
    this.addSql(`DROP INDEX IF EXISTS idx_customer_sust_landfill;`);
    this.addSql(`DROP INDEX IF EXISTS idx_customer_sust_water;`);
    this.addSql(`DROP INDEX IF EXISTS idx_customer_sust_co2;`);

    this.addSql(`ALTER TABLE public.customer DROP CONSTRAINT IF EXISTS customer_landfill_reduced_nonneg;`);
    this.addSql(`ALTER TABLE public.customer DROP CONSTRAINT IF EXISTS customer_water_saved_nonneg;`);
    this.addSql(`ALTER TABLE public.customer DROP CONSTRAINT IF EXISTS customer_co2_saved_nonneg;`);

    this.addSql(`
      ALTER TABLE public.customer
        DROP COLUMN IF EXISTS landfill_reduced_kg,
        DROP COLUMN IF EXISTS water_saved_liters,
        DROP COLUMN IF EXISTS co2_saved_kg;
    `);
  }
}
