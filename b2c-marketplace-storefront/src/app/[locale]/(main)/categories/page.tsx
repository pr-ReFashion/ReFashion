// app/[locale]/products/page.tsx
import { Suspense } from "react"
import { Breadcrumbs } from "@/components/atoms"
import { ProductListingSkeleton } from "@/components/organisms/ProductListingSkeleton/ProductListingSkeleton"
import { ProductListing } from "@/components/sections/ProductListing/ProductListing"
import { PRODUCT_LIMIT } from "@/const"

type PageProps = {
    params: { locale: string }
    searchParams?: { page?: string; limit?: string }
}

export default async function AllProducts({ params, searchParams }: PageProps) {
    const { locale } = params
    const page = Math.max(1, Number(searchParams?.page ?? 1))
    const pageSize = Math.max(1, Number(searchParams?.limit ?? PRODUCT_LIMIT))

    return (
        <main className="container">
            <div className="hidden md:block mb-2">
                <Breadcrumbs items={[{ path: "/", label: "All Products" }]} />
            </div>
            <h1 className="heading-xl uppercase">All Products</h1>

            <Suspense key={`${locale}-${page}-${pageSize}`} fallback={<ProductListingSkeleton />}>
                <ProductListing locale={locale} page={page} pageSize={pageSize} />
            </Suspense>
        </main>
    )
}
