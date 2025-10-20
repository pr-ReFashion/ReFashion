"use client"

import { useMemo } from "react"
import { useSearchParams } from "next/navigation"
import useUpdateSearchParams from "./useUpdateSearchParams"

export const usePagination = (defaultLimit = 12) => {
    const sp = useSearchParams()
    const updateSearchParams = useUpdateSearchParams()

    const currentPage = useMemo(() => {
        const raw = sp.get("page")
        const n = Number(raw)
        return Number.isFinite(n) && n > 0 ? Math.floor(n) : 1
    }, [sp])

    const limit = useMemo(() => {
        const raw = sp.get("limit")
        const n = Number(raw)
        return Number.isFinite(n) && n > 0 ? Math.floor(n) : defaultLimit
    }, [sp, defaultLimit])

    const setPage = (page: number | string) => {
        // keep limit stable so the server knows the page size
        if (!sp.get("limit")) {
            updateSearchParams("limit", String(limit), { replace: true })
        }
        updateSearchParams("page", String(page))
    }

    return { currentPage, limit, setPage }
}
