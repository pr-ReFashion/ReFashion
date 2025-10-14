"use client"
import { HttpTypes } from "@medusajs/types"
import LocalizedClientLink from "@/components/molecules/LocalizedLink/LocalizedLink"
import { cn } from "@/lib/utils"
import { useParams } from "next/navigation"
import { CollapseIcon } from "@/icons"

export const CategoryNavbar = ({
  categories,
  onClose,
}: {
  categories: HttpTypes.StoreProductCategory[]
  onClose?: (state: boolean) => void
}) => {
  const { category } = useParams()

  return (
    <nav className="flex md:items-center flex-col md:flex-row">
      {/* All Products link */}
      <LocalizedClientLink
        href="/categories"
        onClick={() => (onClose ? onClose(false) : null)}
        className={cn(
          "label-md uppercase px-4 my-3 md:my-0 flex items-center justify-between transition-colors duration-200",
          "text-black hover:text-[rgb(var(--brand-500))]"
        )}
      >
        All Products
      </LocalizedClientLink>

      {/* Dynamic category links */}
      {categories?.map(({ id, handle, name }) => (
        <LocalizedClientLink
          key={id}
          href={`/categories/${handle}`}
          onClick={() => (onClose ? onClose(false) : null)}
          className={cn(
            "label-md uppercase px-4 my-3 md:my-0 flex items-center justify-between transition-colors duration-200",
            "text-black hover:text-[rgb(var(--brand-500))]",
            handle === category && "md:border-b-2 md:border-[rgb(var(--brand-600))]"
          )}
        >
          {name}
          <CollapseIcon size={18} className="-rotate-90 md:hidden" />
        </LocalizedClientLink>
      ))}
    </nav>
  )
}

