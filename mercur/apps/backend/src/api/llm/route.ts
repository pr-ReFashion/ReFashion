import type { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"
import http from "http"
import { URL } from "url"

const TARGET = "http://127.0.0.1:11434/api/llm"
const INTERNAL_TOKEN = process.env.LLM_INTERNAL_TOKEN!

export const POST = async (req: MedusaRequest, res: MedusaResponse) => {
  try {
    const url = new URL(TARGET)

    const proxyReq = http.request(
      {
        method: "POST",
        hostname: url.hostname,
        port: url.port,
        path: url.pathname,
        headers: {
          "content-type": "application/json",
          "x-internal-token": INTERNAL_TOKEN,
        },
      },
      (proxyRes) => {
        res.status(proxyRes.statusCode ?? 502)
        for (const [k, v] of Object.entries(proxyRes.headers)) {
          if (v !== undefined) res.setHeader(k, v as any)
        }
        proxyRes.pipe(res)
      }
    )

    proxyReq.on("error", () => {
      res.status(502).json({ message: "LLM proxy error" })
    })

    req.pipe(proxyReq)
  } catch (e: any) {
    res.status(500).json({ message: e?.message ?? "LLM proxy failed" })
  }
}
