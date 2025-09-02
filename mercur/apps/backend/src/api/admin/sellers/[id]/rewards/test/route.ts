import type { MedusaRequest, MedusaResponse } from "@medusajs/framework"
import { Modules } from "@medusajs/framework/utils"
import { z } from "zod"

export const AUTHENTICATE = false

const Params = z.object({ id: z.string() })
const Body = z.object({ delta: z.coerce.number().int().default(5) })

export const POST = async (req: MedusaRequest, res: MedusaResponse) => {
  const { id } = Params.parse(req.params)
  const { delta } = Body.parse(req.body ?? {})
  const eventBus = req.scope.resolve<any>(Modules.EVENT_BUS)

  const msg = [{ name: "reward.test.increment", data: { seller_id: id, delta } }]
  console.log("[emit]", msg[0]) // για debug

  await eventBus.emit(msg)

  res.json({ emitted: true, topic: msg[0].name, seller_id: id, delta })
}
