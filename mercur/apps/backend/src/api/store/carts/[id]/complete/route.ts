import type { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"
// ΚΑΤΕΥΘΕΙΑΝ από το νέο αρχείο
import { splitAndCompleteCartWorkflowBypass } from "../../../../../workflows/cart/workflows/split-and-complete-cart-bypass"
import { getFormattedOrderSetListWorkflow } from "../../../../../workflows/order-set/workflows"

export const POST = async (req: MedusaRequest, res: MedusaResponse) => {
  const cartId = req.params.id
  console.log("[ROUTE COMPLETE] using SCC BYPASS for", cartId)

  const { result } = await splitAndCompleteCartWorkflowBypass(req.scope).run({
    input: { id: cartId },
    context: { transactionId: cartId },
  })

  const { result: { data } } = await getFormattedOrderSetListWorkflow(req.scope).run({
    input: { filters: { id: result.id } },
  })

  return res.json({ order_set: data[0] })
}
