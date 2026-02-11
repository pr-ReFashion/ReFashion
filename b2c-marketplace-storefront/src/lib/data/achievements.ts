export async function getProductCountByEmail(email: string) {
  const backendUrl = process.env.NEXT_PUBLIC_MEDUSA_BACKEND_URL || "http://localhost:9000"

  const res = await fetch(
    `${backendUrl}/store/achievements?email=${encodeURIComponent(email)}`,
    {
      method: "GET",
      cache: "no-store",
      headers: {
        "x-publishable-api-key": process.env.NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY || "",
      },
    }
  )

  if (!res.ok) {
    return { count: 0 }
  }

  return res.json()
}
