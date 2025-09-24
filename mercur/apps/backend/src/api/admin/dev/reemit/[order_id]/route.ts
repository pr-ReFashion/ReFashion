import type { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"
import { devReemitOrderEventWorkflow } from "../../../../../workflows/dev/reemit-order-event"

export const POST = async (req: MedusaRequest, res: MedusaResponse) => {
  const { order_id } = req.params as { order_id: string }
  const event = (req.query?.event as string) || "order.placed"

  const { result } = await devReemitOrderEventWorkflow(req.scope).run({
    input: { event, id: order_id },
  })

  return res.json({ ok: true, event, order_id, result })
}
