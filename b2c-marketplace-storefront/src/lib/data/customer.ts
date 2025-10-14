"use server"

import { cookies } from "next/headers"
import { revalidateTag } from "next/cache"
import { redirect } from "next/navigation"
import { HttpTypes } from "@medusajs/types"

import medusaError from "../helpers/medusa-error"
import { sdk } from "../config"
import {
    getAuthHeaders,
    getCacheOptions,
    getCacheTag,
    getCartId,
    removeAuthToken,
    removeCartId,
    setAuthToken,
} from "./cookies"

/* =========================================================================
   Config & Helpers
   ========================================================================= */

const API_BASE = "http://localhost:9000"

/** "name@domain.com" -> "name.refashion@domain.com" */
function toSellerEmail(customerEmail: string) {
    const at = customerEmail.indexOf("@")
    return at === -1
        ? `${customerEmail}.refashion`
        : `${customerEmail.slice(0, at)}.refashion${customerEmail.slice(at)}`
}

function parseJwtExp(jwt: string): Date | undefined {
    try {
        const [, payload] = jwt.split(".")
        const json = JSON.parse(Buffer.from(payload, "base64url").toString("utf8"))
        if (json?.exp && Number.isFinite(json.exp)) return new Date(json.exp * 1000)
    } catch {}
    return undefined
}

/** httpOnly cookie for server-side usage (secure) */
function setSellerCookie(token: string) {
    const expiry = parseJwtExp(token)
    cookies().set("seller_token", token, {
        httpOnly: true,
        secure: process.env.NODE_ENV === "production",
        sameSite: "lax",
        path: "/",
        ...(expiry ? { expires: expiry } : {}),
    })
}

/** readable cookie so vendor-panel (:5173) JS can pick it up once */
function setSellerCookieReadable(token: string) {
    const expiry = parseJwtExp(token)
    cookies().set("seller_token_js", token, {
        httpOnly: false, // JS-readable (dev convenience for cross-port handoff)
        secure: process.env.NODE_ENV === "production",
        sameSite: "lax",
        path: "/",
        ...(expiry ? { expires: expiry } : {}),
    })
}

function clearSellerCookies() {
    cookies().set("seller_token", "", {
        httpOnly: true,
        secure: process.env.NODE_ENV === "production",
        sameSite: "lax",
        path: "/",
        expires: new Date(0),
    })
    cookies().set("seller_token_js", "", {
        httpOnly: false,
        secure: process.env.NODE_ENV === "production",
        sameSite: "lax",
        path: "/",
        expires: new Date(0),
    })
}

/* =========================================================================
   Customer Reads
   ========================================================================= */

export const retrieveCustomer = async (): Promise<HttpTypes.StoreCustomer | null> => {
    const authHeaders = await getAuthHeaders()
    if (!authHeaders) return null

    const headers = { ...authHeaders }
    const next = { ...(await getCacheOptions("customers")) }

    return await sdk.client
        .fetch<{ customer: HttpTypes.StoreCustomer }>(`/store/customers/me`, {
            method: "GET",
            query: { fields: "*orders" },
            headers,
            next,
            cache: "no-cache",
        })
        .then(({ customer }) => customer)
        .catch(() => null)
}

/* =========================================================================
   Customer Updates
   ========================================================================= */

export const updateCustomer = async (body: HttpTypes.StoreUpdateCustomer) => {
    const headers = { ...(await getAuthHeaders()) }

    const updateRes = await sdk.store.customer
        .update(body, {}, headers)
        .then(({ customer }) => customer)
        .catch((err) => {
            throw new Error(err.message)
        })

    const cacheTag = await getCacheTag("customers")
    revalidateTag(cacheTag)

    return updateRes
}

/* =========================================================================
   Seller/Vendor creation (server-safe)
   ========================================================================= */

export async function signupAndCreateVendorSeller(email: string, password: string , sellerName: string, sellerPhone: string) {
    // 1) Seller signup -> get token
    const signupRes = await fetch(`${API_BASE}/auth/seller/emailpass/register`, {
        method: "POST",
        headers: { Accept: "application/json", "Content-Type": "application/json" },
        body: JSON.stringify({ email, password }),
    })
    if (!signupRes.ok) throw new Error(await signupRes.text())
    const { token } = (await signupRes.json()) as { token: string }

    // 2) Create vendor seller using JWT
    const vendorRes = await fetch(`${API_BASE}/vendor/sellers`, {
        method: "POST",
        headers: {
            Accept: "application/json",
            "Content-Type": "application/json",
            Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({
            registration_type: "business",
            name: sellerName,
            email, // keep consistent
            phone: sellerPhone,
            company_name: sellerName,
            vat_number: "vat number",
            tax_office: "tax office",
            member: { name: sellerName, email },
        }),
    })
    if (!vendorRes.ok) throw new Error(await vendorRes.text())

    return await vendorRes.json()
}

/* =========================================================================
   Customer + Seller Sign Up
   ========================================================================= */

export async function signup(formData: FormData) {
    const password = formData.get("password") as string
    const customerForm = {
        email: formData.get("email") as string,
        first_name: formData.get("first_name") as string,
        last_name: formData.get("last_name") as string,
        phone: formData.get("phone") as string,
    }

    try {
        // 1) Register customer (SDK)
        const token = await sdk.auth.register("customer", "emailpass", {
            email: customerForm.email,
            password,
        })

        // 2) Create SELLER + VENDOR (derived email)
        const sellerEmail = customerForm.email+".refashion"
        const sellerName = customerForm.first_name+" "+customerForm.last_name
        const sellerPhone = customerForm.phone

        await signupAndCreateVendorSeller(sellerEmail, password , sellerName, sellerPhone)

        // 3) Persist customer auth (cookie)
        await setAuthToken(token as string)

        // 4) Create store customer record
        const headers = { ...(await getAuthHeaders()) }
        const { customer: createdCustomer } = await sdk.store.customer.create(
            customerForm,
            {},
            headers
        )

        // 5) Login customer and refresh cookie
        const loginToken = await sdk.auth.login("customer", "emailpass", {
            email: customerForm.email,
            password,
        })
        await setAuthToken(loginToken as string)

        const customerCacheTag = await getCacheTag("customers")
        revalidateTag(customerCacheTag)

        // 6) Transfer cart
        await transferCart()

        // 7) SELLER login and set cookies (httpOnly + readable for :5173)
        try {
            const sellerLoginRes = await fetch(`${API_BASE}/auth/seller/emailpass`, {
                method: "POST",
                headers: { Accept: "application/json", "Content-Type": "application/json" },
                body: JSON.stringify({ email: sellerEmail, password }),
            })
            if (sellerLoginRes.ok) {
                const { token: sellerToken } = (await sellerLoginRes.json()) as { token: string }
                setSellerCookie(sellerToken)          // secure, httpOnly
                setSellerCookieReadable(sellerToken)  // readable handoff for :5173
            } else {
                console.warn("Seller login after signup failed:", await sellerLoginRes.text())
            }
        } catch (e) {
            console.warn("Seller login after signup threw:", e)
        }

        return createdCustomer
    } catch (error: any) {
        return error.toString()
    }
}
/**
 * Server action: ensure we can log in as the seller for the current customer.
 * Returns { ok: true, token } on success, otherwise { ok: false }.
 */
export async function getVendorToken(): Promise<{ ok: boolean; token?: string }> {
    // must be logged in as a customer to know the email
    const me = await retrieveCustomer().catch(() => null)
    const email = me?.email
    if (!email) return { ok: false }

    // you need the customer password for a true seller login only if your seller auth requires it.
    // In our earlier flow we used the same password at signup. If your API allows login without password
    // (e.g., exchange), adapt accordingly. Here we try a direct seller login with the same email derivation.
    const sellerEmail =email+".refashion"

    // IMPORTANT: if your seller login needs a password and you don't have it here,
    // consider using a seller session exchange endpoint. For now we attempt with a stored/known pattern.
    // If your backend requires password and you don't have it, this will fail and we fall back.

    // Try to log in seller WITHOUT asking the user again (best effort).
    // If your backend requires the password, you can store a short-lived seller token earlier
    // (during customer login) and return it here from a server-side store/session.
    try {
        // If you *do* have the password in session, include it instead of "unused"
        const resp = await fetch(`${API_BASE}/auth/seller/emailpass`, {
            method: "POST",
            headers: { Accept: "application/json", "Content-Type": "application/json" },
            // ⚠️ If your backend requires the real password: you must replace "unused"
            // with the real password stored server-side, or implement a token-exchange endpoint.
            body: JSON.stringify({ email: sellerEmail, password: "unused" }),
            cache: "no-store",
        })
        if (!resp.ok) return { ok: false }
        const { token } = (await resp.json()) as { token: string }
        return { ok: true, token }
    } catch {
        return { ok: false }
    }
}
/* =========================================================================
   Customer + Seller Login
   ========================================================================= */

export async function login(formData: FormData) {
    const email = String(formData.get("email") || "")
    const password = String(formData.get("password") || "")


    // 1) Customer login
    try {
        const token = await sdk.auth.login("customer", "emailpass", { email, password })
        await setAuthToken(token as string)
        const tag = await getCacheTag("customers")
        revalidateTag(tag)
    } catch (err: any) {
        return { ok: false, error: err?.toString?.() || "Customer login failed" }
    }

    // 2) Transfer cart (best-effort)
    try { await transferCart() } catch {}

    // 3) Seller login (return the token for client redirect)
    try {
        const sellerEmail = email + ".refashion"
        const resp = await fetch(`${API_BASE}/auth/seller/emailpass`, {
            method: "POST",
            headers: { Accept: "application/json", "Content-Type": "application/json" },
            body: JSON.stringify({ email: sellerEmail, password }),
            cache: "no-store",
        })

        if (!resp.ok) {
            const msg = await resp.text().catch(() => resp.statusText)
            console.warn("Seller login failed:", msg)
            return { ok: true, vendorToken: null } // continue to /user
        }

        const { token: sellerToken } = (await resp.json()) as { token: string }

        // Optional: set on 3000 for your own SSR, but client will redirect using vendorToken
        // setSellerCookie(sellerToken)
        // setSellerCookieReadable(sellerToken)

        return { ok: true, vendorToken: sellerToken }
    } catch (e) {
        console.warn("Seller login error:", e)
        return { ok: true, vendorToken: null }
    }
}


/* =========================================================================
   Customer + Seller Signout
   ========================================================================= */

export async function signout() {
    // Kick off parallel tasks (don't wait one-by-one)
    const [customerTag, cartTag] = await Promise.all([
        getCacheTag("customers"),
        getCacheTag("carts"),
    ])

    // Clear customer auth + cart in parallel
    await Promise.allSettled([
        sdk.auth.logout(),
        removeAuthToken(),
        removeCartId(),
    ])

    // Clear seller cookies (httpOnly + readable) — synchronous
    clearSellerCookies()

    // Revalidate caches in parallel (best-effort)
    await Promise.allSettled([
        revalidateTag(customerTag),
        revalidateTag(cartTag),
    ])

    // Bounce through vendor-panel logout so it can clear *its* localStorage/session,
    // then return the user to storefront home.
    const returnTo = encodeURIComponent("http://localhost:3000/")
    redirect(`http://localhost:5173/auth/logout?return=${returnTo}`)
}

/* =========================================================================
   Cart Transfer
   ========================================================================= */

export async function transferCart() {
    const cartId = await getCartId()
    if (!cartId) return

    const headers = await getAuthHeaders()
    await sdk.store.cart.transferCart(cartId, {}, headers)

    const cartCacheTag = await getCacheTag("carts")
    revalidateTag(cartCacheTag)
}

/* =========================================================================
   Addresses
   ========================================================================= */

export const addCustomerAddress = async (formData: FormData): Promise<any> => {
    const address = {
        address_name: formData.get("address_name") as string,
        first_name: formData.get("first_name") as string,
        last_name: formData.get("last_name") as string,
        company: formData.get("company") as string,
        address_1: formData.get("address_1") as string,
        city: formData.get("city") as string,
        postal_code: formData.get("postal_code") as string,
        country_code: formData.get("country_code") as string,
        phone: formData.get("phone") as string,
        province: formData.get("province") as string,
        is_default_billing: Boolean(formData.get("isDefaultBilling")),
        is_default_shipping: Boolean(formData.get("isDefaultShipping")),
    }

    const headers = { ...(await getAuthHeaders()) }

    return sdk.store.customer
        .createAddress(address, {}, headers)
        .then(async ({ customer }) => {
            const customerCacheTag = await getCacheTag("customers")
            revalidateTag(customerCacheTag)
            return { success: true, error: null }
        })
        .catch((err) => {
            return { success: false, error: err.toString() }
        })
}

export const deleteCustomerAddress = async (addressId: string): Promise<void> => {
    const headers = { ...(await getAuthHeaders()) }

    await sdk.store.customer
        .deleteAddress(addressId, headers)
        .then(async () => {
            const customerCacheTag = await getCacheTag("customers")
            revalidateTag(customerCacheTag)
            return { success: true, error: null }
        })
        .catch((err) => {
            return { success: false, error: err.toString() }
        })
}

export const updateCustomerAddress = async (formData: FormData): Promise<any> => {
    const addressId = formData.get("addressId") as string
    if (!addressId) {
        return { success: false, error: "Address ID is required" }
    }

    const address = {
        address_name: formData.get("address_name") as string,
        first_name: formData.get("first_name") as string,
        last_name: formData.get("last_name") as string,
        company: formData.get("company") as string,
        address_1: formData.get("address_1") as string,
        address_2: formData.get("address_2") as string,
        city: formData.get("city") as string,
        postal_code: formData.get("postal_code") as string,
        province: formData.get("province") as string,
        country_code: formData.get("country_code") as string,
    } as HttpTypes.StoreUpdateCustomerAddress

    const phone = formData.get("phone") as string
    if (phone) {
        address.phone = phone
    }

    const headers = { ...(await getAuthHeaders()) }

    return sdk.store.customer
        .updateAddress(addressId, address, {}, headers)
        .then(async () => {
            const customerCacheTag = await getCacheTag("customers")
            revalidateTag(customerCacheTag)
            return { success: true, error: null }
        })
        .catch((err) => {
            return { success: false, error: err.toString() }
        })
}
