import { useEffect } from "react"

/**
 * Global token handoff:
 * - If path is /auth/accept and ?token=<JWT> exists:
 *    -> store it (localStorage key: "medusa_auth_token")
 *    -> navigate to /dashboard (change if your home path differs)
 * - Otherwise, does nothing.
 */
export default function AcceptHandoff() {
    useEffect(() => {
        if (typeof window === "undefined") return

        const { pathname, search } = window.location
        if (pathname !== "/auth/accept") return

        const params = new URLSearchParams(search)
        const token = params.get("token")

        if (token) {
            // Persist for API calls (your axios/fetch should read this and set Authorization: Bearer)
            localStorage.setItem("medusa_auth_token", token)

            // Optional: also drop a readable cookie for any other code that wants it
            document.cookie = `seller_token_js=${token}; path=/`

            // Clean redirect to your vendor home (adjust if needed)
            window.location.replace("/dashboard")
        } else {
            // No token -> go to login
            window.location.replace("/login")
        }
    }, [])

    return null
}
