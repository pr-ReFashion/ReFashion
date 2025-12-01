import { Suspense } from "react"
import { notFound } from "next/navigation"
import type { Metadata } from "next"
import { ProductListingSkeleton } from "@/components/organisms/ProductListingSkeleton/ProductListingSkeleton"
import { ProductListing } from "@/components/sections"
import { Breadcrumbs } from "@/components/atoms"
import { getCategoryByHandle } from "@/lib/data/categories"
import { generateCategoryMetadata } from "@/lib/helpers/seo"

export async function generateMetadata({
  params,
}: {
  params: Promise<{ category: string }>
}): Promise<Metadata> {
  const { category } = await params
  const decodedHandle = decodeURIComponent(category) // 🔥 fix double-encoding

  const cat = await getCategoryByHandle([decodedHandle])

  return generateCategoryMetadata(cat)
}

async function Category({
  params,
}: {
  params: Promise<{
    category: string
    locale: string
  }>
}) {
  const { category, locale } = await params
  const decodedHandle = decodeURIComponent(category) // 🔥 fix double-encoding

  const cat = await getCategoryByHandle([decodedHandle])

  if (!cat) {
    return notFound()
  }

  const breadcrumbsItems = [
    {
      path: cat?.handle,
      label: cat?.name,
    },
  ]

  return (
    <main className="container">
      <div className="hidden md:block mb-2">
        <Breadcrumbs items={breadcrumbsItems} />
      </div>

      <h1 className="heading-xl uppercase">{cat.name}</h1>

      <Suspense fallback={<ProductListingSkeleton />}>
        <ProductListing category_id={cat.id} showSidebar />
      </Suspense>
    </main>
  )
}

export default Category
