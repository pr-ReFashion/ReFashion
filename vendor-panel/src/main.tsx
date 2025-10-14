// import React from "react"
// import ReactDOM from "react-dom/client"
// import App from "./app.js"
//
// ReactDOM.createRoot(document.getElementById("root")!).render(
//   <React.StrictMode>
//     <App />
//   </React.StrictMode>
// )
import React from "react"
import ReactDOM from "react-dom/client"
import App from "./app.js"

// --- Bootstrap: read seller_token_js -> store -> clear ---
function readCookie(name: string) {
    return document.cookie
        .split("; ")
        .find((r) => r.startsWith(name + "="))
        ?.split("=")[1]
}

function bootstrapSellerAuthFromCookie() {
    try {
        const token = readCookie("seller_token_js")
        if (token) {
            console.warn("tokenIn the Vendor : ", token)
            // Persist for API calls from vendor-panel
            localStorage.setItem("medusa_auth_token", token)
            // Optional cleanup: remove the readable cookie in the browser
            document.cookie = "seller_token_js=; Max-Age=0; path=/"
        }
    } catch (e) {
        console.warn("Bootstrap seller auth failed:", e)
    }
}

// Run BEFORE rendering the app
bootstrapSellerAuthFromCookie()
// ---------------------------------------------------------

ReactDOM.createRoot(document.getElementById("root")!).render(
    <React.StrictMode>
        <App />
    </React.StrictMode>
)

