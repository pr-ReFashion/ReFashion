import * as React from "react"
import { useEffect, useMemo, useState } from "react"
import { defineRouteConfig } from "@medusajs/admin-sdk"
import { Heading, Text, clx } from "@medusajs/ui"

/* ---------- Icons ---------- */
function CO2Icon({ className }: { className?: string }) {
  return (
    <svg className={className} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.4" strokeLinecap="round" strokeLinejoin="round">
      <path d="M6 13.5a3 3 0 0 1 1-5.8A3.5 3.5 0 0 1 14 7.5a3 3 0 0 1 4 3 2.5 2.5 0 0 1-1.5 4.5H7.5A1.5 1.5 0 0 1 6 13.5Z" />
      <text x="11.8" y="12.4" textAnchor="middle" fontSize="4.5" fontFamily="system-ui, -apple-system, BlinkMacSystemFont, sans-serif">CO</text>
    </svg>
  )
}
function WaterIcon({ className }: { className?: string }) {
  return (
    <svg className={className} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
      <path d="M12 3.5C10 6.5 7 9.5 7 13a5 5 0 0 0 10 0c0-3.5-3-6.5-5-9.5Z" />
    </svg>
  )
}
function LandfillIcon({ className }: { className?: string }) {
  return (
    <svg className={className} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
      <path d="M9 4h6" />
      <path d="M10 4l.5-1h3L14 4" />
      <path d="M7 6h10l-.7 11.2A1.5 1.5 0 0 1 14.8 19H9.2a1.5 1.5 0 0 1-1.5-1.4L7 6Z" />
      <path d="M10 9v6" />
      <path d="M14 9v6" />
    </svg>
  )
}

/* ---------- Register page (adds left menu entry) ---------- */
export const config = defineRouteConfig({
  label: "Impact Overview",
  icon: (props: any) => <CO2Icon className={clx("size-4", props?.className)} />,
})

/* ---------- Small stat card ---------- */
function Stat({
  icon,
  value,
  unit,
  label,
}: {
  icon: React.ReactNode
  value: string
  unit?: string
  label: string
}) {
  return (
    <div className="rounded-md border bg-ui-bg-base p-4">
      <div className="flex items-center gap-3">
        <div className="text-ui-fg-muted">{icon}</div>
        <div className="leading-tight">
          <div className="text-xl font-semibold">
            {value} {unit ? <span className="text-ui-fg-subtle text-base">{unit}</span> : null}
          </div>
          <Text size="small" className="text-ui-fg-subtle">
            {label}
          </Text>
        </div>
      </div>
    </div>
  )
}

/* ---------- Page ---------- */
type Totals = {
  co2_kg: number
  water_liters: number
  landfill_kg: number
}

export default function ImpactPage() {
  const [totals, setTotals] = useState<Totals>({ co2_kg: 0, water_liters: 0, landfill_kg: 0 })
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    let abort = false
    ;(async () => {
      try {
        setError(null)
        setLoading(true)

        const res = await fetch("/admin/impact/summary", { credentials: "include" })
        if (!res.ok) throw new Error(`Request failed: ${res.status}`)
        const data = await res.json()

        if (!abort) {
          setTotals({
            co2_kg: Number(data?.co2_saved_kg_total ?? 0),
            water_liters: Number(data?.water_saved_liters_total ?? 0),
            landfill_kg: Number(data?.landfill_reduced_kg_total ?? 0),
          })
        }
      } catch (e: any) {
        if (!abort) setError(e?.message ?? "Failed to load totals")
      } finally {
        if (!abort) setLoading(false)
      }
    })()
    return () => { abort = true }
  }, [])

  const formatted = useMemo(() => {
    const fmt1 = (n: number) =>
      new Intl.NumberFormat(undefined, { maximumFractionDigits: 1, minimumFractionDigits: 1 }).format(n)
    const fmt0 = (n: number) => new Intl.NumberFormat().format(Math.round(n))
    return {
      co2: fmt1(totals.co2_kg),
      water: fmt0(totals.water_liters),
      landfill: fmt1(totals.landfill_kg),
    }
  }, [totals])

  return (
    <div className="p-6">
      <Heading level="h1" className="mb-6">Impact Overview</Heading>

      {error && (
        <div className="mb-6 rounded-md border border-ui-border-critical bg-ui-bg-subtle p-4">
          <Text className="text-ui-fg-critical">Error:</Text> {error}
        </div>
      )}

      {loading ? (
        <Text>Loading impact numbers…</Text>
      ) : (
        <div className="grid grid-cols-1 gap-4 md:grid-cols-3">
          <Stat icon={<CO2Icon className="size-6" />} value={formatted.co2} unit="kg" label="CO₂ saved" />
          <Stat icon={<WaterIcon className="size-6" />} value={formatted.water} unit="lt" label="Water saved" />
          <Stat icon={<LandfillIcon className="size-6" />} value={formatted.landfill} unit="kg" label="Landfill reduced" />
        </div>
      )}
    </div>
  )
}
