import React, { useEffect } from "react"
import { defineWidgetConfig } from "@medusajs/admin-sdk"

// Simple, dependency-free widget for the login page
const Login: React.FC = () => {
    useEffect(() => {
        // Hide the built-in "Welcome to Medusa" headline if present
        const h = Array.from(document.querySelectorAll("h1,h2,h3")).find((el) =>
            /welcome to medusa/i.test(el.textContent || "")
        )
        if (h) (h as HTMLElement).style.display = "none"
    }, [])

    return (
        <div style={{ textAlign: "center", marginBottom: 12 }}>
            <h1 style={{ fontSize: 22, fontWeight: 600, margin: 0 }}>Welcome to Refashion</h1>
            {/* Optional subtitle */}
            {/* <p style={{ marginTop: 6 }}>Please sign in to continue</p> */}
        </div>
    )
}

export const config = defineWidgetConfig({
    zone: "login.before", // you can switch to "login.after" if you prefer
})

export default Login
