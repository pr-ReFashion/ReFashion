import type { MedusaContainer } from "@medusajs/framework/types"
import { SELLER_MODULE, SellerModuleService } from "@mercurjs/seller"

export const config = {
  event: "reward.test.increment",
}

type Payload = { seller_id: string; delta?: number }

export default async function handle(args: {
  container: MedusaContainer
  data?: Payload
  event?: { name: string; data?: Payload }
}) {
  const { container, data, event } = args || ({} as any)
  const sellerService = container.resolve(SELLER_MODULE) as SellerModuleService

  // Δούλεψε με ό,τι υπάρχει
  const payload: Payload | undefined = data ?? event?.data
  if (!payload?.seller_id) {
    console.warn("[rewards] missing payload", { data, event })
    return
  }

  const delta = Number.isFinite(payload.delta as any) ? (payload.delta as number) : 5
  const total = await sellerService.addRewardPoints(payload.seller_id, delta)
  console.log(`[rewards] ${payload.seller_id} +${delta} => ${total}`)
}
