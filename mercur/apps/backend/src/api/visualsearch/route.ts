import type { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"
import http from "http"
import https from "https"
import { URL } from "url"

const DEFAULT_TARGET = "http://127.0.0.1:9300/visual-search"

function buildTargetUrl(req: MedusaRequest) {
  const url = new URL(DEFAULT_TARGET)

  // forward original query string (?provider=...&scrape=...&max_results=...)
  const qs = req.originalUrl?.split("?")[1] || ""
  if (qs) {
    url.search = url.search ? `${url.search}&${qs}` : `?${qs}`
  }
  return url
}

/** Optional health check */
export const GET = async (_req: MedusaRequest, res: MedusaResponse) => {
  res.json({ ok: true, target: DEFAULT_TARGET })
}

/** Stream the multipart body to FastAPI and stream JSON back */
export const POST = async (req: MedusaRequest, res: MedusaResponse) => {
  try {
    const url = buildTargetUrl(req)
    const isHttps = url.protocol === "https:"
    const lib = isHttps ? https : http
    const port = url.port || (isHttps ? "443" : "80")

    const proxyReq = lib.request(
      {
        method: "POST",
        hostname: url.hostname,
        port,
        path: url.pathname + url.search,
        headers: {
          ...req.headers,
          host: `${url.hostname}:${port}`,
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

    req.pipe(proxyReq)
  } catch (e: any) {
    res.status(500).json({ message: e?.message ?? "Proxy failed" })
  }
}
