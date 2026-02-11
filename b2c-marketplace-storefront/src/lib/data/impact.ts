export interface UserImpact {
  co2_saved_kg: number
  landfill_reduced_kg: number
  water_saved_liters: number
}

export async function getUserImpactByEmail(email: string): Promise<UserImpact> {
  const backendUrl =
    process.env.NEXT_PUBLIC_MEDUSA_BACKEND_URL || "http://localhost:9000"

  const res = await fetch(
    `${backendUrl}/store/impact?email=${encodeURIComponent(email)}`,
    {
      method: "GET",
      cache: "no-store",
      headers: {
        "x-publishable-api-key":
          process.env.NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY || "",
      },
    }
  )

  if (!res.ok) {
    return {
      co2_saved_kg: 0,
      landfill_reduced_kg: 0,
      water_saved_liters: 0,
    }
  }

  return res.json()
}
