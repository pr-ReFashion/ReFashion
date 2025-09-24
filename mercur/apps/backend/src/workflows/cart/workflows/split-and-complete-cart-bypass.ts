import {
  MathBN,
  MedusaError,
  Modules,
  OrderStatus,
  OrderWorkflowEvents,
} from "@medusajs/framework/utils"
import { parallelize, transform, when } from "@medusajs/framework/workflows-sdk"
import {
  createOrdersStep,
  createRemoteLinkStep,
  emitEventStep,
  reserveInventoryStep,
  updateCartsStep,
  useRemoteQueryStep,
} from "@medusajs/medusa/core-flows"
import type { UsageComputedActions } from "@medusajs/types"
import type { CartShippingMethodDTO, CartWorkflowDTO } from "@medusajs/types/dist/cart"
import { WorkflowResponse, createHook, createWorkflow } from "@medusajs/workflows-sdk"

import { OrderSetWorkflowEvents } from "@mercurjs/framework"
import { MARKETPLACE_MODULE } from "@mercurjs/marketplace"
import { SELLER_MODULE } from "@mercurjs/seller"

import { registerUsageStep } from "../../promotions/steps"
import { createSplitOrderPaymentsStep } from "../../split-order-payment/steps"
import {
  createOrderSetStep,
  validateCartSellersStep,
  validateCartShippingOptionsStep,
} from "../steps"
import {
  completeCartFields,
  prepareConfirmInventoryInput,
  prepareLineItemData,
  prepareTaxLinesData,
} from "../utils"

type SplitAndCompleteCartWorkflowInput = { id: string }

export const splitAndCompleteCartWorkflowBypass = createWorkflow(
  { name: "split-and-complete-cart-bypass", idempotent: true },
  function (input: SplitAndCompleteCartWorkflowInput) {
    // Log με πραγματική τιμή (μέσα από transform)
    const cartId = transform({ id: input.id }, ({ id }) => {
      console.log("[SCC BYPASS] cart_id =", id)
      return id
    })

    // Αν υπάρχει ήδη order_set για το cart, μην το ξαναφτιάξεις
    const existingOrderSet = useRemoteQueryStep({
      entry_point: "order_set",
      fields: ["id", "cart_id"],
      variables: { filters: { cart_id: cartId } },
      list: false,
    }).config({ name: "rq-order-set" })

    const orderSet = when({ existingOrderSet }, ({ existingOrderSet }) => !existingOrderSet)
      .then(() => {
        const cart = useRemoteQueryStep({
          entry_point: "cart",
          fields: completeCartFields,
          variables: { id: cartId },
          list: false,
        }).config({ name: "rq-cart" })

        // Διάγνωση: δείξε pc/sessions
        transform({ cart }, ({ cart }) => {
          const pc = cart?.payment_collection
          const sessions = Array.isArray(pc?.payment_sessions) ? pc.payment_sessions : []
          console.log("[SCC CART]", {
            cart_id: cart.id,
            payment_collection_id: pc?.id,
            sessions: sessions.map((s: any) => ({ id: s.id, status: s.status })),
          })
          return true
        })

        // Sellers
        validateCartSellersStep(
          transform({ cart }, ({ cart }) => ({ line_items: cart.items }))
        )

        // Shipping
        const validateCartShippingOptionsInput = transform({ cart }, ({ cart }) => ({
          cart_id: cart.id,
          option_ids: cart.shipping_methods.map((m) => m.shipping_option_id),
        }))
        const { sellerProducts, sellerShippingOptions } =
          validateCartShippingOptionsStep(validateCartShippingOptionsInput)

        // BYPASS πληρωμών: πάρε μόνο το payment_collection_id
        const paymentCollectionId = transform({ cart }, ({ cart }) => {
          const pcId = cart?.payment_collection?.id
          if (!pcId) {
            throw new MedusaError(
              MedusaError.Types.INVALID_DATA,
              "Cart has no payment collection attached"
            )
          }
          return pcId
        })

        // dummy payment “αντικείμενο” για downstream βήματα
        const payment = transform({ paymentCollectionId }, ({ paymentCollectionId }) => ({
          payment_collection_id: paymentCollectionId,
        }))

        // Σπάσε σε orders per seller
        const { ordersToCreate, sellers, variants } = transform(
          { cart, sellerProducts, sellerShippingOptions },
          ({ cart, sellerProducts, sellerShippingOptions }) => {
            const productSellerMap = new Map<string, string>(
              sellerProducts.map((sp) => [sp.product_id, sp.seller_id])
            )
            const shippingOptionSellerMap = new Map<string, string>(
              sellerShippingOptions.map((sp) => [sp.shipping_option_id, sp.seller_id])
            )
            const sellerLineItemsMap = new Map<string, any[]>()
            const sellerShippingMethodsMap = new Map<string, CartShippingMethodDTO>()
            const variantsMap = new Map<string, any>()

            cart.items.forEach((item) => {
              const sellerId = productSellerMap.get(item.variant.product_id)!
              const list = sellerLineItemsMap.get(sellerId) || []
              list.push(item)
              sellerLineItemsMap.set(sellerId, list)
              variantsMap.set(item.variant.id, item.variant)
            })

            cart.shipping_methods.forEach((method) => {
              const sellerId = shippingOptionSellerMap.get(method.shipping_option_id)!
              sellerShippingMethodsMap.set(sellerId, method)
            })

            const sellers = Array.from(sellerLineItemsMap.keys())

            const ordersToCreate = sellers.map((sellerId) => {
              const sm = sellerShippingMethodsMap.get(sellerId)
              if (!sm) {
                throw new MedusaError(
                  MedusaError.Types.INVALID_DATA,
                  "Seller shipping method not found!"
                )
              }

              const items = sellerLineItemsMap.get(sellerId)!.map((item) =>
                prepareLineItemData({
                  item,
                  variant: item.variant,
                  unitPrice: item.unit_price,
                  compareAtUnitPrice: item.compare_at_unit_price,
                  isTaxInclusive: item.is_tax_inclusive,
                  quantity: item.quantity,
                  metadata: item?.metadata,
                  taxLines: item.tax_lines ?? [],
                  adjustments: item.adjustments ?? [],
                })
              )

              const itemAdjustments = items.map((it) => it.adjustments ?? []).flat(1)
              const promoCodes = [...itemAdjustments].map((a) => a.code).filter(Boolean)

              return {
                region_id: cart.region?.id,
                customer_id: cart.customer?.id,
                sales_channel_id: cart.sales_channel_id,
                status: OrderStatus.PENDING,
                email: cart.email,
                currency_code: cart.currency_code,
                shipping_address: cart.shipping_address,
                billing_address: cart.billing_address,
                no_notification: false,
                items,
                promo_codes: promoCodes,
                shipping_methods: [
                  {
                    name: sm.name,
                    description: sm.description,
                    amount: sm.amount,
                    is_tax_inclusive: sm.is_tax_inclusive,
                    shipping_option_id: sm.shipping_option_id,
                    data: sm.data,
                    metadata: sm.metadata,
                    tax_lines: prepareTaxLinesData(sm.tax_lines ?? []),
                  },
                ],
              }
            })

            return {
              ordersToCreate,
              sellers,
              variants: Array.from(variantsMap.values()),
            }
          }
        )

        // promotions usage
        const promotionUsage = transform(
          { cart },
          ({ cart }: { cart: CartWorkflowDTO }) => {
            const promo: UsageComputedActions[] = []
            const itemAdj = (cart.items ?? []).map((i) => i.adjustments ?? []).flat(1)
            const shipAdj = (cart.shipping_methods ?? [])
              .map((m) => m.adjustments ?? [])
              .flat(1)
            for (const a of itemAdj) promo.push({ amount: a.amount, code: a.code! })
            for (const a of shipAdj) promo.push({ amount: a.amount, code: a.code! })
            return promo
          }
        )
        registerUsageStep(promotionUsage)

        // order-set
        const orderSet = createOrderSetStep({
          cart_id: cart.id,
          customer_id: cart.customer_id,
          sales_channel_id: cart.sales_channel_id,
          payment_collection_id: payment.payment_collection_id, // <-- από bypass
        })

        const createdOrders = createOrdersStep(ordersToCreate)

        // split payments (pending)
        const splitPaymentsToCreate = transform(
          { createdOrders, payment },
          ({ createdOrders, payment }) =>
            createdOrders.map((order) => ({
              order_id: order.id,
              status: "pending",
              currency_code: order.currency_code,
              authorized_amount: MathBN.convert(order.summary?.accounting_total || 0).toNumber(),
              payment_collection_id: payment.payment_collection_id, // <-- από bypass
            }))
        )

        // inventory reservation
        const reservationItemsData = transform({ createdOrders }, ({ createdOrders }) =>
          createdOrders.reduce<
            { variant_id: string; quantity: number; id: string }[]
          >((acc, order) => {
            acc.push(
              ...order.items!.map((i) => ({
                variant_id: i.variant_id!,
                quantity: i.quantity,
                id: i.id,
              }))
            )
            return acc
          }, [])
        )
        const formattedInventoryItems = transform(
          { input: { sales_channel_id: cart.sales_channel_id, variants, items: reservationItemsData } },
          prepareConfirmInventoryInput
        )

        // ενημέρωσε cart ως completed
        const updateCartInput = transform({ cart }, ({ cart }) => ({
          id: cart.id,
          completed_at: new Date(),
        }))

        // remote links
        const links = transform(
          { createdOrders, sellers, orderSet, payment },
          ({ createdOrders, sellers, orderSet, payment }) => {
            const sellerOrderLinks = createdOrders.map((order, idx) => ({
              [SELLER_MODULE]: { seller_id: sellers[idx] },
              [Modules.ORDER]: { order_id: order.id },
            }))
            const orderSetOrderLinks = createdOrders.map((order) => ({
              [MARKETPLACE_MODULE]: { order_set_id: orderSet.id },
              [Modules.ORDER]: { order_id: order.id },
            }))
            const orderPaymentLinks = createdOrders.map((order) => ({
              [Modules.ORDER]: { order_id: order.id },
              [Modules.PAYMENT]: { payment_collection_id: payment.payment_collection_id },
            }))
            return [...sellerOrderLinks, ...orderSetOrderLinks, ...orderPaymentLinks]
          }
        )

        const orderPlaced = transform({ createdOrders }, ({ createdOrders }) => ({
          eventName: OrderWorkflowEvents.PLACED,
          data: createdOrders.map((o) => ({ id: o.id })),
        }))

        parallelize(
          createSplitOrderPaymentsStep(splitPaymentsToCreate),
          createRemoteLinkStep(links),
          reserveInventoryStep(formattedInventoryItems),
          updateCartsStep([updateCartInput]),
          emitEventStep(orderPlaced).config({ name: "emit-order-placed-events" }),
          emitEventStep({
            eventName: OrderSetWorkflowEvents.PLACED,
            data: { id: orderSet.id },
          }).config({ name: "emit-order-set-placed-event" })
        )

        return orderSet
      })

    const orderSetId = transform({ orderSet, existingOrderSet }, ({ orderSet, existingOrderSet }) =>
      orderSet ? orderSet.id : existingOrderSet.id
    )
    const orderSetCreatedHook = createHook("orderSetCreated", { orderSetId })

    return new WorkflowResponse({ id: orderSetId }, { hooks: [orderSetCreatedHook] })
  }
)
