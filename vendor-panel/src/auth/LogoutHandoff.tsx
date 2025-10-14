import { useEffect } from "react"

export default function LogoutHandoff() {
    useEffect(() => {
        if (typeof window === "undefined") return

        const { pathname, search } = window.location
        if (pathname !== "/auth/logout") return

        const params = new URLSearchParams(search)
        const ret = params.get("return") || "/"

        try {
            // Clear any vendor-side tokens/session
            localStorage.removeItem("medusa_auth_token")
            localStorage.removeItem("medusa_vendor_token")
            // If you set any readable cookie for dev:
            document.cookie = "seller_token_js=; Max-Age=0; path=/"
        } catch {}

        // Back to storefront (or vendor login if you prefer)
        window.location.replace(ret)
    }, [])

    return null
}
