import { Migration } from "@mikro-orm/migrations"

export class Migration20260401051000_AddSellerRegistrationFields extends Migration {
  async up(): Promise<void> {
    this.addSql(`
      ALTER TABLE public.seller
        ADD COLUMN IF NOT EXISTS registration_type text NULL,
        ADD COLUMN IF NOT EXISTS company_name text NULL,
        ADD COLUMN IF NOT EXISTS vat_number text NULL,
        ADD COLUMN IF NOT EXISTS tax_office text NULL;
    `)
  }

  async down(): Promise<void> {
    this.addSql(`
      ALTER TABLE public.seller
        DROP COLUMN IF EXISTS tax_office,
        DROP COLUMN IF EXISTS vat_number,
        DROP COLUMN IF EXISTS company_name,
        DROP COLUMN IF EXISTS registration_type;
    `)
  }
}
