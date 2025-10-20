// src/components/sections/ProductListing/ProductListing.tsx
import {
    ProductListingActiveFilters,
    ProductListingHeader,
    ProductSidebar,
    ProductsList,
    ProductsPagination,
} from "@/components/organisms"
import { listProductsWithSort } from "@/lib/data/products"

type Props = {
    category_id?: string
    collection_id?: string
    seller_id?: string
    showSidebar?: boolean
    locale?: string
    page: number
    pageSize: number
}

export const ProductListing = async ({
                                         category_id,
                                         collection_id,
                                         seller_id,
                                         showSidebar = false,
                                         locale = process.env.NEXT_PUBLIC_DEFAULT_REGION || "pl",
                                         page,
                                         pageSize,
                                     }: Props) => {
    const offset = (page - 1) * pageSize

    const { response } = await listProductsWithSort({
        seller_id,
        category_id,
        collection_id,
        countryCode: locale,
        sortBy: "created_at",
        queryParams: { limit: pageSize, offset },
    })

    const { products, count: totalCount } = await response as {
        products: any[]
        count?: number
    }

    const count = typeof totalCount === "number" ? totalCount : products.length
    const pages = Math.max(1, Math.ceil(count / pageSize))

    return (
        <div className="py-4">
            <ProductListingHeader total={count} />
            <div className="hidden md:block">
                <ProductListingActiveFilters />
            </div>

            <div className="grid grid-cols-1 md:grid-cols-4 mt-6 gap-4">
                {showSidebar && <ProductSidebar />}
                <section className={showSidebar ? "col-span-3" : "col-span-4"}>
                    <div className="flex flex-wrap gap-4">
                        <ProductsList products={products} />
                    </div>
                    <ProductsPagination pages={pages} />
                </section>
            </div>
        </div>
    )
}
