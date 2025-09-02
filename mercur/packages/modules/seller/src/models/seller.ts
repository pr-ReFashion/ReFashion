import { model } from "@medusajs/framework/utils";

import { StoreStatus } from "@mercurjs/framework";
import { MemberInvite } from "./invite";
import { Member } from "./member";
import { SellerOnboarding } from "./onboarding";

export const Seller = model.define("seller", {
  id: model.id({ prefix: "sel" }).primaryKey(),
  store_status: model.enum(StoreStatus).default(StoreStatus.ACTIVE),
  name: model.text().searchable(),
  handle: model.text().unique(),
  description: model.text().searchable().nullable(),
  photo: model.text().nullable(),
  email: model.text().nullable(),
  phone: model.text().nullable(),
  address_line: model.text().nullable(),
  city: model.text().nullable(),
  state: model.text().nullable(),
  postal_code: model.text().nullable(),
  country_code: model.text().nullable(),
  tax_id: model.text().nullable(),

  // ✅ Νέα πεδία
  registration_type: model.text().nullable(),
  company_name: model.text().nullable(),
  vat_number: model.text().nullable(),
  tax_office: model.text().nullable(),
  reward_points: model.number().default(0),

  members: model.hasMany(() => Member),
  invites: model.hasMany(() => MemberInvite),
  onboarding: model.hasOne(() => SellerOnboarding).nullable(),
});
