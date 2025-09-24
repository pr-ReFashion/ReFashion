import type { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"

type AdjustBody = {
  subject_type: "customer" | "seller"
  subject_id: string
  delta: number
  reason?: string
  meta?: Record<string, unknown>
}

export const POST = async (req: MedusaRequest, res: MedusaResponse) => {
  // Safely read body for both runtimes
  const raw =
    typeof (req as any).json === "function"
      ? await (req as any).json()
      : ((req as any).body ?? {})

  const { subject_type, subject_id, delta, reason, meta } = (raw || {}) as AdjustBody

  if (subject_type !== "customer" && subject_type !== "seller") {
    return res.status(400).json({ message: "subject_type must be 'customer' or 'seller'" })
  }
  if (!subject_id || typeof delta !== "number") {
    return res.status(400).json({ message: "subject_id and numeric delta are required" })
  }

  const rewards = req.scope.resolve("rewardsModuleService") as any
  const newBalance = await rewards.increment(subject_type, subject_id, delta, reason, meta)

  return res.json({ subject_type, subject_id, reward_points: newBalance })
}
