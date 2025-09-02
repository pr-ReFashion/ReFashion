// apps/backend/src/api/admin/sellers/[id]/rewards/increment/route.ts
export const AUTHENTICATE = false

import { SELLER_MODULE, SellerModuleService } from "@mercurjs/seller"
import { MedusaRequest, MedusaResponse } from "@medusajs/framework"
import { z } from "zod"

const Body = z.object({
  delta: z.coerce.number().int().default(5),
})

export const POST = async (req: MedusaRequest, res: MedusaResponse) => {
  const sellerService = req.scope.resolve(SELLER_MODULE) as SellerModuleService
  const { id } = req.params as { id: string }
  const { delta } = Body.parse(req.body)

  const total = await sellerService.addRewardPoints(id, delta)
  res.json({ id, reward_points: total })
}
