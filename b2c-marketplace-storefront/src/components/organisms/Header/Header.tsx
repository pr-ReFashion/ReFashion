import Image from "next/image"
import { HttpTypes } from "@medusajs/types"

import {
  CartDropdown,
  HeadingCategories,
  MobileNavbar,
  Navbar,
} from "@/components/cells"
import { HeartIcon } from "@/icons"
import { InfoIcon } from "@/icons"
import { listCategories } from "@/lib/data/categories"
import { PARENT_CATEGORIES } from "@/const"
import { retrieveCart } from "@/lib/data/cart"
import { UserDropdown } from "@/components/cells/UserDropdown/UserDropdown"
import { retrieveCustomer } from "@/lib/data/customer"
import { getUserWishlists } from "@/lib/data/wishlist"
import { Wishlist } from "@/types/wishlist"
import { Badge } from "@/components/atoms"
import CountrySelector from "@/components/molecules/CountrySelector/CountrySelector"
import { listRegions } from "@/lib/data/regions"
import LocalizedClientLink from "@/components/molecules/LocalizedLink/LocalizedLink"
import { SellNowButton } from "@/components/cells/SellNowButton/SellNowButton"

export const Header = async () => {
  const cart = await retrieveCart().catch(() => null)
  const user = await retrieveCustomer()
  const customer = await retrieveCustomer().catch(() => null)  // ← check login

  let wishlist: Wishlist[] = []
  if (user) {
    const response = await getUserWishlists()
    wishlist = response.wishlists
  }

  const regions = await listRegions()

  const wishlistCount = wishlist?.[0]?.products.length || 0

  const { categories, parentCategories } = (await listCategories({
    headingCategories: PARENT_CATEGORIES,
  })) as {
    categories: HttpTypes.StoreProductCategory[]
    parentCategories: HttpTypes.StoreProductCategory[]
  }

  return (
    <header>
      <div className="flex py-2 lg:px-8 px-4">
        <div className="flex items-center lg:w-1/3">
          <MobileNavbar
            parentCategories={parentCategories}
            childrenCategories={categories}
          />
          <HeadingCategories categories={parentCategories} />
          {customer && (
            <SellNowButton />
          )}
          </div>
        <div className="flex lg:justify-center lg:w-1/3 items-center pl-4 lg:pl-0">
          <LocalizedClientLink href="/" className="text-2xl font-bold">
            <Image
              src="/Logo.svg"
              width={180} //126
              height={60} //40
              alt="Logo"
              priority
            />
          </LocalizedClientLink>
        </div>
        <div className="flex items-center justify-end gap-2 lg:gap-4 w-full lg:w-1/3 py-2">
  <UserDropdown user={user} />
  <LocalizedClientLink
    href="/about_us"
    className="relative group flex items-center"
  >
    <InfoIcon size={20} />

    
    <span
      className="
        absolute -top-8 left-1/2 -translate-x-1/2
        whitespace-nowrap text-xs
        bg-black text-white rounded px-2 py-1
        opacity-0 group-hover:opacity-100
        transition-opacity duration-200
        pointer-events-none
      "
    >
      About ReFashion
    </span>
  </LocalizedClientLink>

  {user && (
    <LocalizedClientLink href="/user/wishlist" className="relative">
      <HeartIcon size={20} />
      {Boolean(wishlistCount) && (
        <Badge className="absolute -top-2 -right-2 w-4 h-4 p-0">
          {wishlistCount}
        </Badge>
      )}
    </LocalizedClientLink>
  )}

  <CartDropdown cart={cart} />
  <CountrySelector regions={regions} />
</div>

      </div>
      <Navbar categories={categories} />
    </header>
  )
}
