"use server"

import { sdk } from "../config"

/**
 * Fetches the number of completed purchases for a given email.
 * Handles errors gracefully and always returns a number.
 */
export const getPurchasesByEmail = async (email: string): Promise<number> => {
  if (!email) return 0

  // Optional: normalize email
  const normalizedEmail = email.trim().toLowerCase()

  try {
    const data = await sdk.client.fetch<{ count: number }>(
      `/store/purchase?email=${encodeURIComponent(normalizedEmail)}`
    )

    // Ensure we always return a number
    return typeof data.count === "number" ? data.count : 0
  } catch (err) {
    console.error("Failed to fetch purchases:", err)
    return 0
  }
}
