"use client"

import { useEffect, useState } from "react"
import Link from "next/link"
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

export const SellNowButton = () => {
    const [href, setHref] = useState("http://localhost:5173/login")

    useEffect(() => {
        let token: string | null = null
        try { token = localStorage.getItem("medusa_vendor_token") } catch {}
        if (!token) {
            token = document.cookie.split("; ").find(r => r.startsWith("seller_token_js="))?.split("=")[1] || null
        }
        setHref(
            `http://localhost:5173/auth/accept?token=${encodeURIComponent(token)}`
           )
    }, [])


    return (

        <Link href={href}>
            <Button className="group uppercase !font-bold pl-12 gap-1 flex items-center">
                Sell now
                <ArrowRightIcon
                    color="white"
                    className="w-5 h-5 group-hover:opacity-100 opacity-0 transition-all duration-300"
                />
            </Button>
        </Link>
    )
}
