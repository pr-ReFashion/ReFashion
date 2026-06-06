/**
 * middleware/auth.js
 *
 * Simple API key authentication.
 *
 * Design decision:
 * - We use a static API key (shared secret) rather than JWT because:
 *   1. The only caller is the main backend — not end users.
 *   2. No need for token expiry or user identity inside our API.
 *   3. Simple to implement and audit.
 *
 * The key is passed in the Authorization header as:
 *   Authorization: Bearer <API_KEY>
 *
 * In production you can rotate keys by updating the env var and redeploying.
 * For multi-tenant or higher security needs, replace with a DB-backed key store.
 */

function requireApiKey(req, res, next) {
  const authHeader = req.headers["authorization"];

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({ error: "Missing Authorization header" });
  }

  const providedKey = authHeader.slice(7); // strip "Bearer "

  if (!process.env.API_KEY) {
    console.error("API_KEY is not set in environment — all requests will be rejected");
    return res.status(500).json({ error: "Server misconfiguration" });
  }

  if (providedKey !== process.env.API_KEY) {
    return res.status(403).json({ error: "Invalid API key" });
  }

  next();
}

module.exports = { requireApiKey };
