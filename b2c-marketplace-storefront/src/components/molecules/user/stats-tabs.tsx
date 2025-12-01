"use client"

import AchievementCard from "@/components/organisms/AchievementCard/AchievementCard"
import { useState } from "react"
import clsx from "clsx"
import React from "react"

type TabId = "stats" | "tokens" | "impact" | "achievements"

const TABS: { id: TabId; label: string }[] = [
    { id: "stats", label: "STATS" },
    { id: "tokens", label: "TOKENS VIEW" },
    { id: "impact", label: "IMPACT VIEW" },
    { id: "achievements", label: "ACHIEVEMENTS VIEW" },
]

export function StatsTabs() {
    const [activeTab, setActiveTab] = useState<TabId>("stats") // default STATS

    return (
        <div className="flex flex-col gap-4">
            {/* Tab buttons */}
            <div className="border-b border-gray-200">
                <div className="flex flex-wrap gap-2">
                    {TABS.map((tab) => (

                        <button
                            key={tab.id}
                            type="button"
                            onClick={() => setActiveTab(tab.id)}
                            className={clsx(
                                "px-4 py-2 text-xs md:text-sm font-semibold uppercase tracking-wide",
                                "border-b-2 -mb-[1px] transition-colors",
                                activeTab === tab.id
                                    ? "border-black text-black"
                                    : "border-transparent text-gray-500 hover:text-black hover:border-gray-300"
                            )}
                        >
                            {tab.label}
                        </button>
                    ))}
                </div>
            </div>

            {/* Tab content */}
            <div className="rounded-md border border-gray-200 p-4">

                {activeTab === "stats" && (
                    <div className="space-y-4">
                        <p className="text-sm text-gray-600">
                            A high-level snapshot of your circular fashion impact, combining
                            Tokens, Sustainability Impact and Achievements.
                        </p>

                        {/* 3 boxes – mobile: vertical, md+: 3 columns */}
                        <div className="grid gap-4 md:grid-cols-3">
                            {/* My Tokens card */}
                            <button
                                type="button"
                                onClick={() => setActiveTab("tokens")}
                                className="flex flex-col rounded-xl border border-gray-200 p-4 text-left hover:shadow-sm transition-shadow"
                            >
                                {/* Title line */}
                                <div className="mb-3">
                                    <h3 className="text-base font-semibold">My Tokens</h3>
                                </div>

                                {/* Icon + content centered */}
                                <div className="flex flex-1 flex-col items-center justify-center gap-2">
                                    {/* Big icon under title, centered */}
                                    <div className="flex h-20 w-20 items-center justify-center rounded-full bg-violet-50">
                                        <TokensIcon className="h-14 w-14 text-violet-500" />
                                    </div>

                                    <p className="mt-1 text-3xl font-bold">680 RFT</p>
                                    <p className="text-xs text-gray-500">Your current balance</p>
                                </div>

                                {/* Arrow */}
                                <div className="mt-3 flex items-center justify-end">
                                    <span className="text-lg text-gray-400">{">"}</span>
                                </div>
                            </button>

                            {/* My Impact card */}
                            <button
                                type="button"
                                onClick={() => setActiveTab("impact")}
                                className="flex flex-col rounded-xl border border-gray-200 p-4 text-left hover:shadow-sm transition-shadow"
                            >
                                {/* Title line */}
                                <div className="mb-3">
                                    <h3 className="text-base font-semibold">My Impact</h3>
                                </div>

                                {/* Icon + 3 metrics centered */}
                                <div className="flex flex-1 flex-col items-center justify-center gap-3">
                                    {/* Big category icon */}
                                    <div className="flex h-20 w-20 items-center justify-center rounded-full bg-violet-50">
                                        <ImpactIcon className="h-14 w-14 text-violet-500" />
                                    </div>

                                    {/* 3 metrics with their own small icons – όπως στο mockup */}
                                    <div className="flex w-full items-end justify-between gap-3">
                                        {/* CO2 */}
                                        <div className="flex flex-col items-center gap-1 text-center">
                                            <CO2Icon className="h-8 w-8 text-violet-400" />
                                            <p className="text-lg font-bold">8.4 kg</p>
                                            <p className="text-[11px] text-gray-500 leading-tight">
                                                CO₂
                                                <br />
                                                saved
                                            </p>
                                        </div>

                                        {/* Water */}
                                        <div className="flex flex-col items-center gap-1 text-center">
                                            <WaterIcon className="h-8 w-8 text-violet-400" />
                                            <p className="text-lg font-bold">587 lt</p>
                                            <p className="text-[11px] text-gray-500 leading-tight">
                                                Water
                                                <br />
                                                saved
                                            </p>
                                        </div>

                                        {/* Landfill */}
                                        <div className="flex flex-col items-center gap-1 text-center">
                                            <LandfillIcon className="h-8 w-8 text-violet-400" />
                                            <p className="text-lg font-bold">2.4 kg</p>
                                            <p className="text-[11px] text-gray-500 leading-tight">
                                                Landfill
                                                <br />
                                                reduced
                                            </p>
                                        </div>
                                    </div>
                                </div>

                                {/* Arrow */}
                                <div className="mt-3 flex items-center justify-end">
                                    <span className="text-lg text-gray-400">{">"}</span>
                                </div>
                            </button>

                            {/* My Achievements card */}
                            <button
                                type="button"
                                onClick={() => setActiveTab("achievements")}
                                className="flex flex-col rounded-xl border border-gray-200 p-4 text-left hover:shadow-sm transition-shadow"
                            >
                                {/* Title line */}
                                <div className="mb-3">
                                    <h3 className="text-base font-semibold">My Achievements</h3>
                                </div>

                                {/* Icon + content centered */}
                                <div className="flex flex-1 flex-col items-center justify-center gap-2">
                                    {/* Big icon under title, centered */}
                                    <div className="flex h-20 w-20 items-center justify-center rounded-full bg-violet-50">
                                        <AchievementsIcon className="h-14 w-14 text-violet-500" />
                                    </div>

                                    <p className="mt-1 text-3xl font-bold">3</p>
                                    <p className="text-xs text-gray-500">Badges</p>
                                </div>

                                {/* Arrow */}
                                <div className="mt-3 flex items-center justify-end">
                                    <span className="text-lg text-gray-400">{">"}</span>
                                </div>
                            </button>
                        </div>
                    </div>
                )}

                {activeTab === "tokens" && (
                    <div>
                        <h2 className="label-md mb-2">Tokens view</h2>
                        <p className="mb-4 text-sm text-gray-600">
                            Here you can show detailed token history, accrual, redemption, and
                            rules.
                        </p>
                        {/* TODO: πραγματικό περιεχόμενο Tokens */}
                    </div>
                )}

                {activeTab === "impact" && (
                    <div>
                        <h2 className="label-md mb-2">Impact view</h2>
                        <p className="mb-4 text-sm text-gray-600">
                            Detailed breakdown of your sustainability impact: CO₂ saved,
                            water saved, landfill reduced, etc.
                        </p>
                        {/* TODO: πραγματικό περιεχόμενο Impact */}
                    </div>
                )}

                {activeTab === "achievements" && (
    <div>
        <h2 className="label-md mb-2">Achievements</h2>
        <p className="mb-4 text-sm text-gray-600">
            Badges, levels and milestones you've unlocked through your activity.
        </p>

        <div className="grid gap-4 md:grid-cols-2">

    <AchievementCard
        title="Welcome to ReFashion"
        description="Create your account on ReFashion"
        image="/images/achievements/refashion.png"
        progress={1}
        total={1}
    />                

    <AchievementCard
        title="First Sale"
        description="Sell your first item on ReFashion"
        image="/images/achievements/1st-sell.png"
        progress={1}
        total={1}
    />

    <AchievementCard
        title="First Purchase"
        description="Buy your first secondhand item"
        image="/images/achievements/1st-buy.png"
        progress={1}
        total={1}
    />

    <AchievementCard
        title="Consistent Seller"
        description="Complete 5 sales"
        image="/images/achievements/con-seller.png"
        progress={4}
        total={5}
    />

    <AchievementCard
        title="Consistent Buyer"
        description="Complete 5 purchases"
        image="/images/achievements/con-buyer.png"
        progress={5}
        total={5}
    />

    <AchievementCard
        title="Super Seller"
        description="Complete 10 sales"
        image="/images/achievements/super-seller.png"
        progress={4}
        total={10}
    />

    <AchievementCard
        title="Super Buyer"
        description="Complete 10 purchases"
        image="/images/achievements/super-buyer.png"
        progress={5}
        total={10}
    />

    <AchievementCard
        title="Vintage Ambassador"
        description="List 5 vintage items"
        image="/images/achievements/vintage.png"
        progress={0}
        total={5}
    />

    <AchievementCard
        title="Personal Impact"
        description="Reached 5 kg CO2 , 500 Lt water, or 10 kg landfill savings."
        image="/images/achievements/personal-impact.png"
        progress={0}
        total={3}
    />

    <AchievementCard
        title="One of a Kind"
        description="Listed 3 premium items with proof of authenticity and original packaging."
        image="/images/achievements/one-of-a-kind.png"
        progress={1}
        total={3}
    />

    <AchievementCard
        title="ReFashion Star"
        description="Received 50 hearts from fellow fashion lovers."
        image="/images/achievements/refashion-star.png"
        progress={50}
        total={50}
    />

</div>
    </div>
)}

            </div>
        </div>
    )
}

/* ====== Icons ====== */

function TokensIcon({ className }: { className?: string }) {
    return (
        <svg
            className={className}
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="1.6"
            strokeLinecap="round"
            strokeLinejoin="round"
        >
            <ellipse cx="12" cy="6" rx="5" ry="3" />
            <path d="M7 6v4c0 1.7 2.2 3 5 3s5-1.3 5-3V6" />
            <path d="M7 13v3c0 1.7 2.2 3 5 3s5-1.3 5-3v-3" />
        </svg>
    )
}

function ImpactIcon({ className }: { className?: string }) {
    // γενικό εικονίδιο impact (σταγόνα/φύλλο)
    return (
        <svg
            className={className}
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="1.6"
            strokeLinecap="round"
            strokeLinejoin="round"
        >
            <path d="M12 3C9.5 6.5 7 9.2 7 12.2 7 15 9.2 17 12 17s5-2 5-4.8C17 9.2 14.5 6.5 12 3z" />
            <path d="M9.5 11.5c.7.3 1.3.5 2.5.5 1.2 0 1.8-.2 2.5-.5" />
        </svg>
    )
}

function CO2Icon({ className }: { className?: string }) {
    return (
        <svg
            className={className}
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="1.4"
            strokeLinecap="round"
            strokeLinejoin="round"
        >
            <path d="M6 13.5a3 3 0 0 1 1-5.8A3.5 3.5 0 0 1 14 7.5a3 3 0 0 1 4 3 2.5 2.5 0 0 1-1.5 4.5H7.5A1.5 1.5 0 0 1 6 13.5Z" />
            <text
                x="11.8"
                y="12.4"
                textAnchor="middle"
                fontSize="4.5"
                fontFamily="system-ui, -apple-system, BlinkMacSystemFont, sans-serif"
            >
                CO
            </text>
        </svg>
    )
}

function WaterIcon({ className }: { className?: string }) {
    return (
        <svg
            className={className}
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="1.6"
            strokeLinecap="round"
            strokeLinejoin="round"
        >
            <path d="M12 3.5C10 6.5 7 9.5 7 13a5 5 0 0 0 10 0c0-3.5-3-6.5-5-9.5Z" />
        </svg>
    )
}

function LandfillIcon({ className }: { className?: string }) {
    return (
        <svg
            className={className}
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="1.6"
            strokeLinecap="round"
            strokeLinejoin="round"
        >
            <path d="M9 4h6" />
            <path d="M10 4l.5-1h3L14 4" />
            <path d="M7 6h10l-.7 11.2A1.5 1.5 0 0 1 14.8 19H9.2a1.5 1.5 0 0 1-1.5-1.4L7 6Z" />
            <path d="M10 9v6" />
            <path d="M14 9v6" />
        </svg>
    )
}

function AchievementsIcon({ className }: { className?: string }) {
    return (
        <svg
            className={className}
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="1.6"
            strokeLinecap="round"
            strokeLinejoin="round"
        >
            <circle cx="12" cy="8" r="3.5" />
            <path d="M8 14c1.2-1 2.6-1.5 4-1.5s2.8.5 4 1.5" />
            <path d="M9 15v4l3-1.5 3 1.5v-4" />
        </svg>
    )
}



