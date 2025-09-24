import type { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"
import rewardsOnOrder, { config as rewardsConfig } from "../../../../../subscribers/rewards-on-order"

export const POST = async (req: MedusaRequest, res: MedusaResponse) => {
  const { order_id } = req.params as { order_id: string }
  const force = String(req.query?.force ?? "") === "true"

  await rewardsOnOrder({
    container: req.scope as any,
    pluginOptions: { force },                // <— lets you rerun
    event: { name: rewardsConfig.event, data: { id: order_id } },
  } as any)

  return res.json({ ok: true, forced: force, order_id, event: rewardsConfig.event })
}
