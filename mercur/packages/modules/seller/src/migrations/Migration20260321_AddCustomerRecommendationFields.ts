import { Migration } from '@mikro-orm/migrations';

export class Migration20260321_AddCustomerRecommendationFields extends Migration {
  async up(): Promise<void> {
    this.addSql(`
      ALTER TABLE public.customer
        ADD COLUMN IF NOT EXISTS rec_product_id1 TEXT NULL,
        ADD COLUMN IF NOT EXISTS rec_product_id2 TEXT NULL,
        ADD COLUMN IF NOT EXISTS rec_product_id3 TEXT NULL;
    `);
  }

  async down(): Promise<void> {
    this.addSql(`
      ALTER TABLE public.customer
        DROP COLUMN IF EXISTS rec_product_id3,
        DROP COLUMN IF EXISTS rec_product_id2,
        DROP COLUMN IF EXISTS rec_product_id1;
    `);
  }
}