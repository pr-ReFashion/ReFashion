import { createWorkflow, WorkflowResponse } from "@medusajs/workflows-sdk"
import { emitEventStep } from "@medusajs/medusa/core-flows"

type Input = { event: string; id: string }

export const devReemitOrderEventWorkflow = createWorkflow(
  { name: "dev-reemit-order-event" },
  (input: Input) => {
    // unique name so we never clash with other workflows
    emitEventStep({
      eventName: input.event,
      data: { id: input.id },
    }).config({ name: "dev-reemit" })

    return new WorkflowResponse({ ok: true })
  }
)
