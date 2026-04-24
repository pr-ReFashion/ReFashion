import type { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"
import http from "http"
import { URL } from "url"

const TARGET = "http://127.0.0.1:9400/recommend/trigger/stop"
const API_KEY = "my-super-secret-code"

export const POST = async (req: MedusaRequest, res: MedusaResponse) => {
  try {
    const incomingKey = req.headers["x-api-key"]

    if (incomingKey !== API_KEY) {
      return res.status(401).json({ message: "Unauthorized" })
    }

    const targetUrl = new URL(TARGET)

    const proxyReq = http.request(
      {
        method: "POST",
        hostname: targetUrl.hostname,
        port: targetUrl.port,
        path: targetUrl.pathname + targetUrl.search,
        headers: {
          host: `${targetUrl.hostname}:${targetUrl.port}`,
        },
      },
      (proxyRes) => {
        res.status(proxyRes.statusCode ?? 502)

        for (const [k, v] of Object.entries(proxyRes.headers)) {
          if (typeof v !== "undefined") {
            res.setHeader(k, v as any)
          }
        }

        proxyRes.pipe(res)
      }
    )

    proxyReq.on("error", (err) => {
      res.status(502).json({ message: "Proxy error", error: String(err) })
    })

    proxyReq.end()
  } catch (e: any) {
    res.status(500).json({ message: e?.message ?? "Proxy failed" })
  }
}