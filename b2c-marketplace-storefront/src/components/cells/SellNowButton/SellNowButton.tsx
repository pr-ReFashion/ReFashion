"use client"

import { Button } from "@/components/atoms"
import { ArrowRightIcon } from "@/icons"

function readCookie(name: string) {
  if (typeof document === "undefined") return null
  return (
    document.cookie
      .split("; ")
      .find((r) => r.startsWith(name + "="))
      ?.split("=")[1] || null
  )
}

const VENDOR_URL =
  process.env.NEXT_PUBLIC_VENDOR_PANEL_URL || "http://localhost:5173"

export const SellNowButton = () => {
  const handleClick = () => {
    // try localStorage first
    let token: string | null = null
    try {
      token = localStorage.getItem("medusa_vendor_token")
    } catch {}

    // then cookie fallback
    if (!token) {
      token = readCookie("seller_token_js")
    }

    const base = VENDOR_URL.replace(/\/$/, "")
    const target = token
      ? `${base}/auth/accept?token=${encodeURIComponent(token)}`
      : `${base}/login` // graceful fallback if no token yet

    window.location.href = target
  }

  return (
    <Button onClick={handleClick} className="group uppercase !font-bold pl-12 gap-1 flex items-center">
      Sell now
      <ArrowRightIcon
        color="white"
        className="w-5 h-5 group-hover:opacity-100 opacity-0 transition-all duration-300"
      />
    </Button>
  )
}
