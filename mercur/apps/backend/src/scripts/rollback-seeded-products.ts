import { ExecArgs } from "@medusajs/framework/types"
import { Modules } from "@medusajs/framework/utils"
import { deleteProductsWorkflow } from "@medusajs/medusa/core-flows"

function chunk<T>(arr: T[], size: number): T[][] {
  const out: T[][] = []
  for (let i = 0; i < arr.length; i += size) {
    out.push(arr.slice(i, i + size))
  }
  return out
}

export default async function rollbackSeededProducts({ container }: ExecArgs) {
  const logger = container.resolve("logger")
  const productModuleService = container.resolve(Modules.PRODUCT)

  const limit = 200
  let offset = 0
  let total = 0
  const idsToDelete: string[] = []

  do {
    const [products, count] = await productModuleService.listAndCountProducts(
      {},
      { select: ["id", "handle"], take: limit, skip: offset }
    )

    total = count
    offset += products.length

    for (const p of products) {
      if (p.handle?.startsWith("seed-")) {
        idsToDelete.push(p.id)
      }
    }
  } while (offset < total)

  if (!idsToDelete.length) {
    logger.info("No seeded products found (handle starts with seed-).")
    return
  }

  const batches = chunk(idsToDelete, 100)
  for (const [i, batch] of batches.entries()) {
    await deleteProductsWorkflow(container).run({
      input: { ids: batch },
    })
    logger.info(`Deleted batch ${i + 1}/${batches.length}`)
  }

  logger.info(`Done. Rolled back ${idsToDelete.length} seeded products.`)
}
