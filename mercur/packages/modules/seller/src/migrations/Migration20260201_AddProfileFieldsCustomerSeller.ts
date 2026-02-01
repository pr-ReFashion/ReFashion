import { Migration } from "@mikro-orm/migrations"

export class Migration20260201_AddProfileFieldsCustomerSeller extends Migration {
  async up(): Promise<void> {
    // CUSTOMER
    this.addSql(`
      ALTER TABLE public.customer
        ADD COLUMN IF NOT EXISTS date_of_birth date NULL,
        ADD COLUMN IF NOT EXISTS job text NULL,
        ADD COLUMN IF NOT EXISTS interests text NULL;
    `)

    // SELLER
    this.addSql(`
      ALTER TABLE public.seller
        ADD COLUMN IF NOT EXISTS date_of_birth date NULL,
        ADD COLUMN IF NOT EXISTS job text NULL,
        ADD COLUMN IF NOT EXISTS interests text NULL;
    `)

    // DOB should not be in the future (safe constraint add)
    this.addSql(`
      DO $$
      BEGIN
        IF NOT EXISTS (
          SELECT 1 FROM pg_constraint WHERE conname = 'customer_dob_not_future'
        ) THEN
          ALTER TABLE public.customer
            ADD CONSTRAINT customer_dob_not_future
            CHECK (date_of_birth IS NULL OR date_of_birth <= CURRENT_DATE);
        END IF;

        IF NOT EXISTS (
          SELECT 1 FROM pg_constraint WHERE conname = 'seller_dob_not_future'
        ) THEN
          ALTER TABLE public.seller
            ADD CONSTRAINT seller_dob_not_future
            CHECK (date_of_birth IS NULL OR date_of_birth <= CURRENT_DATE);
        END IF;
      END
      $$;
    `)
  }

  async down(): Promise<void> {
    // Drop constraints first
    this.addSql(`ALTER TABLE public.customer DROP CONSTRAINT IF EXISTS customer_dob_not_future;`)
    this.addSql(`ALTER TABLE public.seller   DROP CONSTRAINT IF EXISTS seller_dob_not_future;`)

    // CUSTOMER
    this.addSql(`
      ALTER TABLE public.customer
        DROP COLUMN IF EXISTS interests,
        DROP COLUMN IF EXISTS job,
        DROP COLUMN IF EXISTS date_of_birth;
    `)

    // SELLER
    this.addSql(`
      ALTER TABLE public.seller
        DROP COLUMN IF EXISTS interests,
        DROP COLUMN IF EXISTS job,
        DROP COLUMN IF EXISTS date_of_birth;
    `)
  }
}
