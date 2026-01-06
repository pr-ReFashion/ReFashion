"use server"

import { sdk } from "../config"

/**
 * Fetches the number of sales for a given email.
 * Normalizes the email by appending '.refashion' if missing.
 *
 * @param email - The customer email (without .refashion)
 * @returns number of sales
 */
export const getSalesByEmail = async (email: string): Promise<number> => {
  // Normalize email to match database
  const normalizedEmail = email.endsWith(".refashion")
    ? email
    : `${email}.refashion`

  // Fetch from your backend endpoint
  return sdk.client
    .fetch<{ count: number }>(`/store/sales?email=${encodeURIComponent(normalizedEmail)}`)
    .then(({ count }) => (typeof count === "number" ? count : 0))
    .catch((err) => {
      console.error("Failed to fetch sales:", err)
      return 0
    })
}
