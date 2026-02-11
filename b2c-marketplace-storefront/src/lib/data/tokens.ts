export async function getTokens(email: string) {
  const backendUrl = process.env.NEXT_PUBLIC_MEDUSA_BACKEND_URL || "http://localhost:9000"

  const res = await fetch(
    `${backendUrl}/store/tokens?email=${encodeURIComponent(email)}`,
    {
      method: "GET",
      cache: "no-store",
      headers: {
        "x-publishable-api-key": process.env.NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY || "",
      },
    }
  )

  if (!res.ok) {
    return 0
  }

  const data = await res.json()

  return data.totalRewards ?? 0
}
