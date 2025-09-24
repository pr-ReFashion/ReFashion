import { ShippingOptionDTO } from '@medusajs/framework/types'
import {
  ContainerRegistrationKeys,
  arrayDifference,
} from '@medusajs/framework/utils'
import { StepResponse, createStep } from '@medusajs/framework/workflows-sdk'

import sellerProduct from '../../../links/seller-product'
import sellerShippingOption from '../../../links/seller-shipping-option'

export const filterSellerShippingOptionsStep = createStep(
  'filter-seller-shipping-options',
  async (
    input: { shipping_options?: ShippingOptionDTO[]; cart_id: string },
    { container }
  ) => {
    const query = container.resolve(ContainerRegistrationKeys.QUERY)

    // 1) Cart (safe)
    const { data: carts = [] } = await query.graph({
      entity: 'cart',
      fields: ['items.product_id', 'shipping_methods.shipping_option_id'],
      filters: { id: input.cart_id },
    })
    const cart = carts[0] ?? { items: [], shipping_methods: [] }
    const items = Array.isArray(cart.items) ? cart.items : []
    const existing = Array.isArray(cart.shipping_methods) ? cart.shipping_methods : []

    // 2) Sellers in cart
    const { data: sellersInCart = [] } = await query.graph({
      entity: sellerProduct.entryPoint,
      fields: ['seller_id'],
      filters: { product_id: items.map((i: any) => i?.product_id).filter(Boolean) },
    })

    const existingShippingOptions = existing
      .map((sm: any) => sm?.shipping_option_id)
      .filter(Boolean)

    const { data: sellersAlreadyCovered = [] } = await query.graph({
      entity: sellerShippingOption.entryPoint,
      fields: ['seller_id'],
      filters: { shipping_option_id: existingShippingOptions },
    })

    const sellersToFindShippingOptions = arrayDifference(
      [...new Set(sellersInCart.map((s: any) => s?.seller_id).filter(Boolean))],
      [...new Set(sellersAlreadyCovered.map((s: any) => s?.seller_id).filter(Boolean))]
    )

    // 3) Seller ↔ ShippingOption relations (safe filters)
    const { data: sellerShippingOptions = [] } = await query.graph({
      entity: sellerShippingOption.entryPoint,
      fields: ['shipping_option_id', 'seller.name', 'seller.id'],
      // αν είναι κενό, μη βάλεις filter για να μην πετάει error
      filters: sellersToFindShippingOptions.length
        ? { seller_id: sellersToFindShippingOptions }
        : {},
    })

    const baseOptions = Array.isArray(input?.shipping_options)
      ? (input!.shipping_options as ShippingOptionDTO[])
      : []

    // Fallback: αν δεν υπάρχει καθόλου mapping, ΜΗΝ μπλοκάρεις — επέστρεψε ό,τι ήρθε
    if (!sellerShippingOptions.length) {
      return new StepResponse(baseOptions)
    }

    const applicableIds = new Set(
      sellerShippingOptions
        .map((so: any) => so?.shipping_option_id)
        .filter(Boolean)
    )

    const optionsAvailable = baseOptions
      .filter((option) => applicableIds.has(option.id))
      .map((option) => {
        const relation = sellerShippingOptions.find(
          (o: any) => o?.shipping_option_id === option.id
        )
        return {
          ...option,
          seller_name: relation?.seller?.name ?? null,
          seller_id: relation?.seller?.id ?? null,
        }
      })

    return new StepResponse(optionsAvailable)
  }
)
