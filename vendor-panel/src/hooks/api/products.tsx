import { FetchError } from "@medusajs/js-sdk"
import { HttpTypes } from "@medusajs/types"
import {
  QueryKey,
  useMutation,
  UseMutationOptions,
  useQuery,
  UseQueryOptions,
} from "@tanstack/react-query"
import { fetchQuery, importProductsQuery, sdk } from "../../lib/client"
import { queryClient } from "../../lib/query-client"
import { queryKeysFactory } from "../../lib/query-key-factory"
import { inventoryItemsQueryKeys } from "./inventory.tsx"
import {
  checkCategoryMatch,
  checkCollectionMatch,
  checkTagMatch,
  checkTypeMatch,
  checkStatusMatch,
} from "./helpers/productFilters"
import productsImagesFormatter from "../../utils/products-images-formatter"

/**********************************************************************
 *                      CUSTOM CODE START
 **********************************************************************/
import { inventoryItemLevelsQueryKeys } from "./inventory"

//Seller for the address
type Seller = {
  address_line?: string
  address_line_2?: string
  city?: string
  company?: string
  company_name?: string
  name?: string
  country_code?: string        // may be localized (e.g. "Ελλάδα")
  phone?: string
  postal_code?: string
  province?: string
  state?: string | null
}

type MeResponse = {
  member?: {
    id?: string
    email?: string
    role?: string
    name?: string
    phone?: string | null
    photo?: string | null
    seller?: Seller
    seller_id?: string
  }
}

function normalizeCountry(code?: string) {
  return (code || "").trim().toUpperCase()
}

function buildAddressFromSeller(seller?: Seller) {
  const company =
    seller?.company ??
    seller?.company_name ??
    seller?.name ??
    "Default"

  return {
    name: "Default",        // change to company if you prefer
    address: {
      address_1:   seller?.address_line      ?? "",
      address_2:   seller?.address_line_2    ?? "",
      city:        seller?.city              ?? "",
      company,
      country_code: seller?.country_code,
      phone:        seller?.phone            ?? "",
      postal_code:  seller?.postal_code      ?? "",
      province:     seller?.province ?? (seller?.state ?? "") ?? "",
    },
  }
}
// === Auto stock seeding (vendor endpoints only, NO nested inventory_item populate) ===
type VariantWithInv = {
  id: string
  inventory_items?: Array<{
    id: string
    inventory_item_id?: string
  }>
}

async function vGET<T = any>(path: string, query?: Record<string, any>): Promise<T> {
  return await fetchQuery(path, { method: "GET", query: query as any })
}
async function vPOST<T = any>(path: string, body?: any): Promise<T> {
  return await fetchQuery(path, { method: "POST", body })
}

// 1) Ensure a stock location exists; if not, create one with your fixed data
async function ensureStockLocationId(): Promise<string | undefined> {
  // 1) reuse existing (prefer default)
  const list = await vGET("/vendor/stock-locations")
  const existingDefault = list?.stock_locations?.find((l: any) => l.is_default)
  const existingAny = existingDefault?.id || list?.stock_locations?.[0]?.id
  if (existingAny) return existingAny

  // 2) load /vendor/me and extract seller
  const me = await vGET<MeResponse>("/vendor/me", undefined, "Load /vendor/me")
  const seller = me?.member?.seller
  console.log("[ensureStockLocationId] seller →", seller)

  // 3) build payload from seller
  const payload = buildAddressFromSeller(seller)
  console.log("[ensureStockLocationId] creating stock location with payload →", payload)

  const created = await vPOST("/vendor/stock-locations", payload)
  const locId = created?.stock_location?.id
  console.log("[ensureStockLocationId] created stock location id:", locId)

  return locId
}


// 2) Get variants including their *attachment* rows (no nested inventory_item!)
async function getVariantsWithInvItems(productId: string): Promise<VariantWithInv[]> {
  const res = await vGET(`/vendor/products/${productId}`, {
    fields: "*variants.inventory_items",
  })
  return res?.product?.variants ?? []
}

// 3) Resolve REAL inventory item id (iitem_*) for a variant
async function resolveIItemId(variant: VariantWithInv): Promise<string | undefined> {
  const viaAttachment = variant?.inventory_items?.find(a => a.inventory_item_id)?.inventory_item_id
  if (viaAttachment) return viaAttachment

  try {
    const r = await vGET(`/vendor/product-variants/${variant.id}/inventory-items`)
    const fromVariant = r?.inventory_items?.[0]?.inventory_item_id
    if (fromVariant) return fromVariant
  } catch {
    /* ignore */
  }

  // Last resort: search inventory items by variant_id
  try {
    const q = await vGET("/vendor/inventory-items", { variant_id: variant.id, limit: 1 })
    const found = q?.inventory_items?.[0]?.id // should be iitem_*
    if (found) return found
  } catch {
    /* ignore */
  }

  return undefined
}

// 4) Create/Update the level to qty=1
//    IMPORTANT: Medusa requires the item to be "stocked" at the location BEFORE updates.
//    So we ALWAYS batch-create first (if missing), then set quantity via per-location update.
async function createOrUpdateLevelQty1(iitemId: string, locationId: string) {
  // 1) If level missing, create it via batch (this "stocks" the item at the location)
  const levelList = await vGET(`/vendor/inventory-items/${iitemId}/location-levels`)
  const exists = !!levelList?.location_levels?.some((l: any) => l.location_id === locationId)

  if (!exists) {
    await vPOST(`/vendor/inventory-items/${iitemId}/location-levels/batch`, {
      // NOTE: singular keys for Medusa v2-style endpoints
      create: [{ location_id: locationId, stocked_quantity: 1 }],
      update: [],
      delete: [],
    })
  }

  // 2) Now it’s stocked there; set (or confirm) qty=1
  await vPOST(`/vendor/inventory-items/${iitemId}/location-levels/${locationId}`, {
    stocked_quantity: 1,
  })

  // 3) Invalidate this item's levels so the UI refreshes
  try {
    await queryClient.invalidateQueries({
      queryKey: inventoryItemLevelsQueryKeys.detail(iitemId),
    })
  } catch {}
}


// 4) Main routine called after product creation
async function seedInitialStock(productId: string) {
  const locationId = await ensureStockLocationId()
  if (!locationId) return

  const variants = await getVariantsWithInvItems(productId)
  for (const v of variants) {
    const iitemId = await resolveIItemId(v)
    if (!iitemId) continue
    await createOrUpdateLevelQty1(iitemId, locationId)

    // Also refresh inventory items lists as a whole
    await queryClient.invalidateQueries({ queryKey: inventoryItemsQueryKeys.lists() })
  }
}
/**********************************************************************
 *                         CUSTOM CODE END
 *********************************************************************/



const PRODUCTS_QUERY_KEY = "products" as const
export const productsQueryKeys = queryKeysFactory(PRODUCTS_QUERY_KEY)

const VARIANTS_QUERY_KEY = "product_variants" as const
export const variantsQueryKeys = queryKeysFactory(VARIANTS_QUERY_KEY)

const OPTIONS_QUERY_KEY = "product_options" as const
export const optionsQueryKeys = queryKeysFactory(OPTIONS_QUERY_KEY)

export const useCreateProductOption = (
  productId: string,
  options?: UseMutationOptions<any, FetchError, any>
) => {
  return useMutation({
    mutationFn: (payload: HttpTypes.AdminCreateProductOption) =>
      fetchQuery(`/vendor/products/${productId}/options`, {
        method: "POST",
        body: payload,
      }),
    onSuccess: (data: any, variables: any, context: any) => {
      queryClient.invalidateQueries({
        queryKey: optionsQueryKeys.lists(),
      })
      queryClient.invalidateQueries({
        queryKey: productsQueryKeys.detail(productId),
      })
      options?.onSuccess?.(data, variables, context)
    },
    ...options,
  })
}

export const useUpdateProductOption = (
  productId: string,
  optionId: string,
  options?: UseMutationOptions<any, FetchError, any>
) => {
  return useMutation({
    mutationFn: (payload: HttpTypes.AdminUpdateProductOption) =>
      fetchQuery(`/vendor/products/${productId}/options/${optionId}`, {
        method: "POST",
        body: payload,
      }),
    onSuccess: (data: any, variables: any, context: any) => {
      queryClient.invalidateQueries({
        queryKey: optionsQueryKeys.lists(),
      })
      queryClient.invalidateQueries({
        queryKey: optionsQueryKeys.detail(optionId),
      })
      queryClient.invalidateQueries({
        queryKey: productsQueryKeys.detail(productId),
      })

      options?.onSuccess?.(data, variables, context)
    },
    ...options,
  })
}

export const useDeleteProductOption = (
  productId: string,
  optionId: string,
  options?: UseMutationOptions<any, FetchError, void>
) => {
  return useMutation({
    mutationFn: () =>
      fetchQuery(`/vendor/products/${productId}/options/${optionId}`, {
        method: "DELETE",
      }),
    onSuccess: (data: any, variables: any, context: any) => {
      queryClient.invalidateQueries({
        queryKey: optionsQueryKeys.lists(),
      })
      queryClient.invalidateQueries({
        queryKey: optionsQueryKeys.detail(optionId),
      })
      queryClient.invalidateQueries({
        queryKey: productsQueryKeys.detail(productId),
      })

      options?.onSuccess?.(data, variables, context)
    },
    ...options,
  })
}

export const useProductVariant = (
  productId: string,
  variantId: string,
  query?: HttpTypes.AdminProductVariantParams,
  options?: Omit<
    UseQueryOptions<
      HttpTypes.AdminProductVariantResponse,
      FetchError,
      HttpTypes.AdminProductVariantResponse,
      QueryKey
    >,
    "queryFn" | "queryKey"
  >
) => {
  const { data, ...rest } = useQuery({
    queryFn: async () => {
      const { product } = await fetchQuery(`/vendor/products/${productId}`, {
        method: "GET",
        query: {
          fields:
            "*variants,*variants.inventory,*variants.inventory.location_levels",
        },
      })

      const variant = product.variants.find(
        ({ id }: { id: string }) => id === variantId
      )

      return { variant }
    },
    queryKey: variantsQueryKeys.detail(variantId, query),
    ...options,
  })

  return { ...data, ...rest }
}

export const useProductVariants = (
  productId: string,
  query?: HttpTypes.AdminProductVariantParams,
  options?: Omit<
    UseQueryOptions<
      HttpTypes.AdminProductVariantListResponse,
      FetchError,
      HttpTypes.AdminProductVariantListResponse,
      QueryKey
    >,
    "queryFn" | "queryKey"
  >
) => {
  const { data, ...rest } = useQuery({
    queryFn: () => sdk.admin.product.listVariants(productId, query),
    queryKey: variantsQueryKeys.list({
      productId,
      ...query,
    }),
    ...options,
  })

  return { ...data, ...rest }
}

export const useCreateProductVariant = (
  productId: string,
  options?: UseMutationOptions<any, FetchError, any>
) => {
  return useMutation({
    mutationFn: (payload: HttpTypes.AdminCreateProductVariant) =>
      fetchQuery(`/vendor/products/${productId}/variants`, {
        method: "POST",
        body: payload,
      }),
    onSuccess: (data: any, variables: any, context: any) => {
      queryClient.invalidateQueries({
        queryKey: variantsQueryKeys.lists(),
      })
      queryClient.invalidateQueries({
        queryKey: productsQueryKeys.detail(productId),
      })
      options?.onSuccess?.(data, variables, context)
    },
    ...options,
  })
}

export const useUpdateProductVariant = (
  productId: string,
  variantId: string,
  options?: UseMutationOptions<any, FetchError, any>
) => {
  return useMutation({
    mutationFn: (body: HttpTypes.AdminUpdateProductVariant) =>
      fetchQuery(`/vendor/products/${productId}/variants/${variantId}`, {
        method: "POST",
        body,
      }),
    onSuccess: (data: any, variables: any, context: any) => {
      queryClient.invalidateQueries({
        queryKey: variantsQueryKeys.lists(),
      })
      queryClient.invalidateQueries({
        queryKey: variantsQueryKeys.detail(variantId),
      })
      queryClient.invalidateQueries({
        queryKey: productsQueryKeys.detail(productId),
      })

      options?.onSuccess?.(data, variables, context)
    },
    ...options,
  })
}

export const useUpdateProductVariantsBatch = (
  productId: string,
  options?: UseMutationOptions<any, FetchError, any>
) => {
  return useMutation({
    mutationFn: (
      payload: HttpTypes.AdminBatchProductVariantRequest["update"]
    ) =>
      sdk.admin.product.batchVariants(productId, {
        update: payload,
      }),
    onSuccess: (data: any, variables: any, context: any) => {
      queryClient.invalidateQueries({
        queryKey: variantsQueryKeys.lists(),
      })
      queryClient.invalidateQueries({
        queryKey: variantsQueryKeys.details(),
      })
      queryClient.invalidateQueries({
        queryKey: productsQueryKeys.detail(productId),
      })

      options?.onSuccess?.(data, variables, context)
    },
    ...options,
  })
}

export const useProductVariantsInventoryItemsBatch = (
  productId: string,
  options?: UseMutationOptions<
    HttpTypes.AdminBatchProductVariantInventoryItemResponse,
    FetchError,
    HttpTypes.AdminBatchProductVariantInventoryItemRequest
  >
) => {
  return useMutation({
    mutationFn: (payload) =>
      sdk.admin.product.batchVariantInventoryItems(productId, payload),
    onSuccess: (data: any, variables: any, context: any) => {
      queryClient.invalidateQueries({
        queryKey: variantsQueryKeys.lists(),
      })
      queryClient.invalidateQueries({
        queryKey: variantsQueryKeys.details(),
      })
      queryClient.invalidateQueries({
        queryKey: productsQueryKeys.detail(productId),
      })

      options?.onSuccess?.(data, variables, context)
    },
    ...options,
  })
}

export const useDeleteVariant = (
  productId: string,
  variantId: string,
  options?: UseMutationOptions<any, FetchError, void>
) => {
  return useMutation({
    mutationFn: () =>
      fetchQuery(`/vendor/products/${productId}/variants/${variantId}`, {
        method: "DELETE",
      }),
    onSuccess: (data: any, variables: any, context: any) => {
      queryClient.invalidateQueries({
        queryKey: variantsQueryKeys.lists(),
      })
      queryClient.invalidateQueries({
        queryKey: variantsQueryKeys.detail(variantId),
      })
      queryClient.invalidateQueries({
        queryKey: productsQueryKeys.detail(productId),
      })

      options?.onSuccess?.(data, variables, context)
    },
    ...options,
  })
}

export const useDeleteVariantLazy = (
  productId: string,
  options?: UseMutationOptions<
    HttpTypes.AdminProductVariantDeleteResponse,
    FetchError,
    { variantId: string }
  >
) => {
  return useMutation({
    mutationFn: ({ variantId }) =>
      fetchQuery(`/vendor/products/${productId}/variants/${variantId}`, {
        method: "DELETE",
      }),
    onSuccess: (data, variables, context) => {
      queryClient.invalidateQueries({
        queryKey: variantsQueryKeys.lists(),
      })
      queryClient.invalidateQueries({
        queryKey: variantsQueryKeys.detail(variables.variantId),
      })
      queryClient.invalidateQueries({
        queryKey: productsQueryKeys.detail(productId),
      })

      options?.onSuccess?.(data, variables, context)
    },
    ...options,
  })
}

export const useProductAttributes = (id: string) => {
  const { data, ...rest } = useQuery({
    queryFn: () =>
      fetchQuery(`/vendor/products/${id}/applicable-attributes`, {
        method: "GET",
      }),
    queryKey: ["product", id, "product-attributes"],
  })

  return { ...data, ...rest }
}

export const useProduct = (
  id: string,
  query?: Record<string, any>,
  options?: Omit<
    UseQueryOptions<
      HttpTypes.AdminProductResponse,
      FetchError,
      HttpTypes.AdminProductResponse,
      QueryKey
    >,
    "queryFn" | "queryKey"
  >
) => {
  const { data, ...rest } = useQuery({
    queryFn: () =>
      fetchQuery(`/vendor/products/${id}`, {
        method: "GET",
        query: query as { [key: string]: string | number },
      }),
    queryKey: productsQueryKeys.detail(id),
    ...options,
  })

  return {
    ...data,
    product: productsImagesFormatter(data?.product),
    ...rest,
  }
}

export const useProducts = (
  query?: HttpTypes.AdminProductListParams,
  options?: Omit<
    UseQueryOptions<
      HttpTypes.AdminProductListResponse,
      FetchError,
      HttpTypes.AdminProductListResponse,
      QueryKey
    >,
    "queryFn" | "queryKey"
  >,
  filter?: HttpTypes.AdminProductListParams & {
    tagId?: string | string[]
    categoryId?: string | string[]
    collectionId?: string | string[]
    typeId?: string | string[]
    status?: string | string[]
    q?: string
    sort?: string
  }
) => {
  const { data, ...rest } = useQuery({
    queryFn: () =>
      fetchQuery("/vendor/products", {
        method: "GET",
        query: query as Record<string, string | number>,
      }),
    queryKey: productsQueryKeys.list(),
    ...options,
  })

  let products = data?.products || []

  // Apply filters if any exist
  if (
    filter?.q ||
    filter?.categoryId ||
    filter?.tagId ||
    filter?.collectionId ||
    filter?.typeId ||
    filter?.status
  ) {
    products = products.filter((item) => {
      if (filter.q) {
        return item.title.toLowerCase().includes(filter.q.toLowerCase())
      }

      return (
        (filter.categoryId &&
          checkCategoryMatch(item?.categories, filter.categoryId)) ||
        (filter.tagId && checkTagMatch(item?.tags, filter.tagId)) ||
        (filter.collectionId &&
          checkCollectionMatch(item?.collection, filter.collectionId)) ||
        (filter.typeId && checkTypeMatch(item?.type_id, filter.typeId)) ||
        (filter.status && checkStatusMatch(item?.status, filter.status))
      )
    })
  }

  // Apply sorting if specified
  if (filter?.sort) {
    const isDescending = filter.sort.startsWith("-")
    const field = isDescending ? filter.sort.slice(1) : filter.sort

    if (["title", "created_at", "updated_at"].includes(field)) {
      products = [...products].sort((a, b) => {
        const aValue = a[field as keyof HttpTypes.AdminProduct]
        const bValue = b[field as keyof HttpTypes.AdminProduct]

        if (field === "title") {
          const titleA = String(aValue || "")
          const titleB = String(bValue || "")
          return isDescending
            ? titleB.localeCompare(titleA)
            : titleA.localeCompare(titleB)
        }

        // For dates
        const dateA = new Date((aValue as string) || new Date()).getTime()
        const dateB = new Date((bValue as string) || new Date()).getTime()
        return isDescending ? dateB - dateA : dateA - dateB
      })
    }
  }

  return {
    ...data,
    products: productsImagesFormatter(products?.slice(0, filter?.limit)) || [],
    count: products?.length || 0,
    ...rest,
  }
}

export const useCreateProduct = (
  options?: UseMutationOptions<HttpTypes.AdminProductResponse, FetchError, any>
) => {
  return useMutation({
    mutationFn: async (payload) =>
      await fetchQuery("/vendor/products", {
        method: "POST",
        body: payload,
      }),
    onSuccess: async (data, variables, context) => {
      // refresh early
      await queryClient.invalidateQueries({ queryKey: productsQueryKeys.lists() })
      await queryClient.invalidateQueries({ queryKey: inventoryItemsQueryKeys.lists() })

      try {
        const productId = data?.product?.id
        if (productId) {
          await seedInitialStock(productId)
          // global refresh after seeding
          await queryClient.invalidateQueries({ queryKey: inventoryItemsQueryKeys.lists() })
        }
      } catch {
        // soft-fail; don't block caller
      }

      options?.onSuccess?.(data, variables, context)
    },
    ...options,
  })
}



export const useUpdateProduct = (
  id: string,
  options?: UseMutationOptions<
    HttpTypes.AdminProductResponse,
    FetchError,
    HttpTypes.AdminUpdateProduct
  >
) => {
  return useMutation({
    mutationFn: async (payload) => {
      const { product } = await fetchQuery(`/vendor/products/${id}`, {
        method: "GET",
        query: {
          fields:
            "-status,-options,-variants,-type,-collection,-attribute_values",
        },
      })

      await delete product.id
      await delete product.rating
      await delete payload.status

      return fetchQuery(`/vendor/products/${id}`, {
        method: "POST",
        body: {
          ...product,
          height: parseInt(product.height),
          width: parseInt(product.width),
          weight: parseInt(product.weight),
          length: parseInt(product.length),
          ...payload,
        },
      })
    },
    onSuccess: async (data, variables, context) => {
      await queryClient.invalidateQueries({
        queryKey: productsQueryKeys.lists(),
      })
      await queryClient.invalidateQueries({
        queryKey: productsQueryKeys.detail(id),
      })

      options?.onSuccess?.(data, variables, context)
    },
    ...options,
  })
}

export const useDeleteProduct = (
  id: string,
  options?: UseMutationOptions<
    HttpTypes.AdminProductDeleteResponse,
    FetchError,
    void
  >
) => {
  return useMutation({
    mutationFn: () =>
      fetchQuery(`/vendor/products/${id}`, {
        method: "DELETE",
      }),
    onSuccess: (data: any, variables: any, context: any) => {
      queryClient.invalidateQueries({
        queryKey: productsQueryKeys.lists(),
      })
      queryClient.invalidateQueries({
        queryKey: productsQueryKeys.detail(id),
      })

      options?.onSuccess?.(data, variables, context)
    },
    ...options,
  })
}

export const useExportProducts = (
  query?: HttpTypes.AdminProductListParams,
  options?: UseMutationOptions<
    HttpTypes.AdminExportProductResponse & { url: string },
    FetchError,
    HttpTypes.AdminExportProductRequest
  >
) => {
  return useMutation({
    mutationFn: (payload) =>
      fetchQuery("/vendor/products/export", {
        method: "POST",
        body: payload,
        query: query as { [key: string]: string },
      }),
    onSuccess: (data, variables, context) => {
      options?.onSuccess?.(data, variables, context)
    },
    ...options,
  })
}

export const useImportProducts = (
  options?: UseMutationOptions<
    HttpTypes.AdminImportProductResponse,
    FetchError,
    HttpTypes.AdminImportProductRequest
  >
) => {
  return useMutation({
    mutationFn: (payload) => importProductsQuery(payload.file),
    onSuccess: (data, variables, context) => {
      options?.onSuccess?.(data, variables, context)
    },
    ...options,
  })
}

export const useConfirmImportProducts = (
  options?: UseMutationOptions<{}, FetchError, string>
) => {
  return useMutation({
    mutationFn: (payload) => sdk.admin.product.confirmImport(payload),
    onSuccess: (data, variables, context) => {
      options?.onSuccess?.(data, variables, context)
    },
    ...options,
  })
}
