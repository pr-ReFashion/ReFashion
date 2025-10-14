import { useEffect } from "react";
import { useLocation, useNavigate } from "react-router-dom";

/**
 * Reads ?token=<JWT> from the URL, saves it for API auth,
 * then sends the user to the vendor dashboard.
 *
 * B2C redirects to: http://localhost:5173/auth/accept?token=...
 */
export default function Accept() {
    const location = useLocation();
    const navigate = useNavigate();

    useEffect(() => {
        // read token from querystring
        const params = new URLSearchParams(location.search);
        const token = params.get("token");

        if (token) {
            // Persist for vendor-panel API calls (Bearer)
            localStorage.setItem("medusa_auth_token", token);

            // Optional: if you also use a cookie-based guard somewhere
            document.cookie = `seller_token_js=${token}; path=/`;

            // Navigate to your vendor home
            navigate("/dashboard", { replace: true });
        } else {
            // No token -> go to vendor login
            navigate("/login", { replace: true });
        }
    }, [location.search, navigate]);

    // No UI needed; brief placeholder is fine
    return null;
}
