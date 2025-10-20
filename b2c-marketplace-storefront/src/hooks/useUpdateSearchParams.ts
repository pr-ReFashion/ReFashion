"use client"

import { usePathname, useRouter, useSearchParams } from "next/navigation"

type Opts = {
    replace?: boolean
}

export default function useUpdateSearchParams() {
    const router = useRouter()
    const pathname = usePathname()
    const sp = useSearchParams()

    return (key: string, value: string | null, opts?: Opts) => {
        const next = new URLSearchParams(sp.toString()) // preserve everything else

        if (value === null || value === "") {
            next.delete(key)
        } else {
            next.set(key, value)
        }

        const url = `${pathname}?${next.toString()}`
        if (opts?.replace) router.replace(url)
        else router.push(url)
    }
}
