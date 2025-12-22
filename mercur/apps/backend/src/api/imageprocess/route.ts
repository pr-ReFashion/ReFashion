import type { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"
import http from "http"
import { URL } from "url"

const TARGET = "http://127.0.0.1:9100/api/imageprocess"

/**
 * Optional health check for the proxy path.
 */
export const GET = async (_req: MedusaRequest, res: MedusaResponse) => {
  res.json({ ok: true, target: TARGET })
}

/**
 * Streams the multipart/form-data body to the FastAPI microservice
 * and streams the image response back.
 */
export const POST = async (req: MedusaRequest, res: MedusaResponse) => {
  try {
    const url = new URL(TARGET)

    const proxyReq = http.request(
      {
        method: "POST",
        hostname: url.hostname,
        port: url.port,
        path: url.pathname + url.search,
        headers: {
          ...req.headers,
          host: `${url.hostname}:${url.port}`,
        },
      },
      (proxyRes) => {
        res.status(proxyRes.statusCode ?? 502)
        // forward headers (content-type, etc.)
        for (const [k, v] of Object.entries(proxyRes.headers)) {
          if (typeof v !== "undefined") res.setHeader(k, v as any)
        }
        proxyRes.pipe(res)
      }
    )

    proxyReq.on("error", (err) => {
      res.status(502).json({ message: "Proxy error", error: String(err) })
    })

    req.pipe(proxyReq)
  } catch (e: any) {
    res.status(500).json({ message: e?.message ?? "Proxy failed" })
  }
}
