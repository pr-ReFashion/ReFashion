import { ExecArgs } from "@medusajs/framework/types"
import { Modules, ProductStatus } from "@medusajs/framework/utils"
import {
  createCollectionsWorkflow,
  createProductCategoriesWorkflow,
  createProductsWorkflow,
} from "@medusajs/medusa/core-flows"
import { SELLER_MODULE } from "@mercurjs/seller"

type CategorySeedConfig = {
  category: string
  images: string[]
  titleFormats: string[]
  colors: string[]
  sizeOptions: string[]
  basePrice: number
}

const CATEGORY_CONFIGS: CategorySeedConfig[] = [
  {
    category: "Shoes",
    images: [
      "https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1200&h=1200&q=80",
      "https://images.unsplash.com/photo-1460353581641-37baddab0fa2?auto=format&fit=crop&w=1200&h=1200&q=80",
      "https://images.unsplash.com/photo-1514989940723-e8e51635b782?auto=format&fit=crop&w=1200&h=1200&q=80",
    ],
    titleFormats: ["Running Shoes", "Casual Shoes", "Street Shoes", "Trainer Shoes"],
    colors: ["Black", "White", "Gray", "Navy"],
    sizeOptions: ["40", "41", "42", "43", "44"],
    basePrice: 59,
  },
  {
    category: "Jeans",
    images: [
      "https://images.unsplash.com/photo-1542272604-787c3835535d?auto=format&fit=crop&w=1200&h=1200&q=80",
      "https://images.unsplash.com/photo-1582418702059-97ebafb35d09?auto=format&fit=crop&w=1200&h=1200&q=80",
      "https://images.unsplash.com/photo-1604176424472-9d962f69fd07?auto=format&fit=crop&w=1200&h=1200&q=80",
    ],
    titleFormats: ["Slim Fit Jeans", "Straight Jeans", "Relaxed Jeans", "Denim Jeans"],
    colors: ["Dark Blue", "Blue", "Black", "Light Blue"],
    sizeOptions: ["S", "M", "L", "XL"],
    basePrice: 49,
  },
  {
    category: "Hoodies",
    images: [
      "https://images.unsplash.com/photo-1556821840-3a63f95609a7?auto=format&fit=crop&w=1200&h=1200&q=80",
      "https://images.unsplash.com/photo-1619603364904-c0498317e145?auto=format&fit=crop&w=1200&h=1200&q=80",
      "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=1200&h=1200&q=80",
    ],
    titleFormats: ["Oversized Hoodie", "Zip Hoodie", "Fleece Hoodie", "Classic Hoodie"],
    colors: ["Black", "Gray", "Beige", "Olive"],
    sizeOptions: ["S", "M", "L", "XL"],
    basePrice: 45,
  },
  {
    category: "T-Shirts",
    images: [
      "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=1200&h=1200&q=80",
      "https://images.unsplash.com/photo-1503341338985-95f92a6d70dd?auto=format&fit=crop&w=1200&h=1200&q=80",
      "https://images.unsplash.com/photo-1562157873-818bc0726f68?auto=format&fit=crop&w=1200&h=1200&q=80",
    ],
    titleFormats: ["Basic T-Shirt", "Cotton T-Shirt", "Oversized T-Shirt", "Graphic T-Shirt"],
    colors: ["White", "Black", "Gray", "Brown"],
    sizeOptions: ["S", "M", "L", "XL"],
    basePrice: 25,
  },
  {
    category: "Jackets",
    images: [
      "https://images.unsplash.com/photo-1521223890158-f9f7c3d5d504?auto=format&fit=crop&w=1200&h=1200&q=80",
      "https://images.unsplash.com/photo-1591047139829-d91aecb6caea?auto=format&fit=crop&w=1200&h=1200&q=80",
      "https://images.unsplash.com/photo-1611312449412-6cefac5dc3e4?auto=format&fit=crop&w=1200&h=1200&q=80",
    ],
    titleFormats: ["Bomber Jacket", "Denim Jacket", "Puffer Jacket", "Light Jacket"],
    colors: ["Black", "Olive", "Navy", "Brown"],
    sizeOptions: ["S", "M", "L", "XL"],
    basePrice: 69,
  },
  {
    category: "Bags",
    images: [
      "https://images.unsplash.com/photo-1548036328-c9fa89d128fa?auto=format&fit=crop&w=1200&h=1200&q=80",
      "https://images.unsplash.com/photo-1491637639811-60e2756cc1c7?auto=format&fit=crop&w=1200&h=1200&q=80",
      "https://images.unsplash.com/photo-1584917865442-de89df76afd3?auto=format&fit=crop&w=1200&h=1200&q=80",
    ],
    titleFormats: ["Crossbody Bag", "Shoulder Bag", "Mini Bag", "Tote Bag"],
    colors: ["Black", "Brown", "Beige", "Gray"],
    sizeOptions: ["One Size"],
    basePrice: 39,
  },
  {
    category: "Dresses",
    images: [
      "https://images.unsplash.com/photo-1496747611176-843222e1e57c?auto=format&fit=crop&w=1200&h=1200&q=80",
      "https://images.unsplash.com/photo-1464863979621-258859e62245?auto=format&fit=crop&w=1200&h=1200&q=80",
      "https://images.unsplash.com/photo-1585487000160-6ebcfceb0d03?auto=format&fit=crop&w=1200&h=1200&q=80",
    ],
    titleFormats: ["Midi Dress", "Mini Dress", "Casual Dress", "Evening Dress"],
    colors: ["Black", "Red", "Beige", "Blue"],
    sizeOptions: ["S", "M", "L"],
    basePrice: 55,
  },
  {
    category: "Accessories",
    images: [
      "https://images.unsplash.com/photo-1523170335258-f5ed11844a49?auto=format&fit=crop&w=1200&h=1200&q=80",
      "https://images.unsplash.com/photo-1617038220319-276d3cfab638?auto=format&fit=crop&w=1200&h=1200&q=80",
      "https://images.unsplash.com/photo-1522312346375-d1a52e2b99b3?auto=format&fit=crop&w=1200&h=1200&q=80",
    ],
    titleFormats: ["Cap", "Belt", "Sunglasses", "Wallet"],
    colors: ["Black", "Brown", "Gray", "Navy"],
    sizeOptions: ["One Size"],
    basePrice: 19,
  },
]

function slugify(value: string) {
  return value
    .toLowerCase()
    .trim()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
}

function chunk<T>(arr: T[], size: number): T[][] {
  const chunks: T[][] = []
  for (let i = 0; i < arr.length; i += size) {
    chunks.push(arr.slice(i, i + size))
  }
  return chunks
}

function pick<T>(arr: T[], index: number): T {
  return arr[index % arr.length]
}

export default async function seed100Products({ container, args }: ExecArgs) {
  const countArg = Number(args?.[0] ?? "100")
  const count = Number.isFinite(countArg) && countArg > 0 ? countArg : 100
  const sellerIdFromArgs = args?.[1]

  const logger = container.resolve("logger")
  const productModuleService = container.resolve(Modules.PRODUCT)
  const salesChannelModuleService = container.resolve(Modules.SALES_CHANNEL)
  const sellerModuleService = container.resolve<any>(SELLER_MODULE)

  logger.info(`Seeding ${count} products...`)

  const [defaultSalesChannel] = await salesChannelModuleService.listSalesChannels(
    { name: "Default Sales Channel" },
    { select: ["id", "name"] }
  )

  if (!defaultSalesChannel?.id) {
    throw new Error(
      'Default Sales Channel not found. Run the base seed first ("npm run seed").'
    )
  }

  const sellers = await sellerModuleService.listSellers({}, { select: ["id", "name"] })
  const sellerId = sellerIdFromArgs || sellers?.[0]?.id

  if (!sellerId) {
    throw new Error(
      'No seller found. Pass seller id as 2nd arg: `medusa exec ./src/scripts/seed-100-products.ts 100 sel_xxx`.'
    )
  }

  const existingCategories = await productModuleService.listProductCategories(
    {},
    { select: ["id", "name"] }
  )
  const existingCategoryMap = new Map(
    existingCategories.map((c) => [c.name.toLowerCase(), c.id])
  )

  const categoryNames = CATEGORY_CONFIGS.map((c) => c.category)
  const missingCategories = categoryNames.filter(
    (name) => !existingCategoryMap.has(name.toLowerCase())
  )

  if (missingCategories.length) {
    await createProductCategoriesWorkflow(container).run({
      input: {
        product_categories: missingCategories.map((name) => ({
          name,
          is_active: true,
        })),
      },
    })
  }

  const allCategories = await productModuleService.listProductCategories(
    {},
    { select: ["id", "name"] }
  )
  const categoryMap = new Map(allCategories.map((c) => [c.name, c.id]))

  const collections = await productModuleService.listProductCollections(
    {},
    { select: ["id", "title"] }
  )

  let collectionId = collections.find((c) => c.title === "Seeded Collection")?.id
  if (!collectionId) {
    const { result } = await createCollectionsWorkflow(container).run({
      input: {
        collections: [{ title: "Seeded Collection" }],
      },
    })
    collectionId = result[0].id
  }

  const runId = Date.now().toString(36)
  const products = Array.from({ length: count }).map((_, index) => {
    const itemNo = index + 1
    const cfg = pick(CATEGORY_CONFIGS, index)
    const categoryName = cfg.category
    const categoryId = categoryMap.get(cfg.category)
    if (!categoryId) {
      throw new Error(`Category "${categoryName}" could not be resolved.`)
    }

    const color = pick(cfg.colors, index)
    const productName = pick(cfg.titleFormats, Math.floor(index / CATEGORY_CONFIGS.length))
    const size = pick(cfg.sizeOptions, index)
    const title = `${color} ${productName}`
    const handle = `seed-${slugify(categoryName)}-${itemNo}-${runId}`
    const price = cfg.basePrice + (index % 7) * 3
    const imageUrl = pick(cfg.images, index)
    const altImageUrl = pick(cfg.images, index + 1)

    return {
      title,
      handle,
      subtitle: `${categoryName} collection`,
      description: `${productName} in ${color}. Auto-generated catalog item for ${categoryName.toLowerCase()}.`,
      is_giftcard: false,
      status: ProductStatus.PUBLISHED,
      discountable: true,
      thumbnail: imageUrl,
      images: [{ url: imageUrl }, { url: altImageUrl }],
      options: [
        { title: "Color", values: cfg.colors },
        { title: "Size", values: cfg.sizeOptions },
        { title: "Condition", values: ["New"] },
      ],
      variants: [
        {
          title: `${color} / ${size} / New`,
          allow_backorder: false,
          manage_inventory: true,
          options: { Color: color, Size: size, Condition: "New" },
          prices: [{ amount: price, currency_code: "eur" }],
        },
      ],
      categories: [{ id: categoryId }],
      collection_id: collectionId,
      sales_channels: [{ id: defaultSalesChannel.id }],
    }
  })

  for (const [i, batch] of chunk(products, 25).entries()) {
    await createProductsWorkflow(container).run({
      input: {
        products: batch,
        additional_data: {
          seller_id: sellerId,
        },
      },
    })
    logger.info(`Inserted batch ${i + 1}/${Math.ceil(products.length / 25)}`)
  }

  logger.info(`Done. Inserted ${products.length} products for seller ${sellerId}.`)
}
