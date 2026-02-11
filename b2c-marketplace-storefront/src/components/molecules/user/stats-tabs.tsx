"use client"

import AchievementCard from "@/components/organisms/AchievementCard/AchievementCard"
import { useState, useEffect } from "react"
import clsx from "clsx"
import React from "react"
import { retrieveCustomer } from "@/lib/data/customer"
import { getTokens } from "@/lib/data/tokens"
import { getUserImpactByEmail, UserImpact } from "@/lib/data/impact"
import { getPurchasesByEmail } from "@/lib/data/purchase"
import { getSalesByEmail } from "@/lib/data/sales"

type TabId = "stats" | "tokens" | "impact" | "achievements"

const TABS: { id: TabId; label: string }[] = [
  { id: "stats", label: "STATS" },
  { id: "tokens", label: "TOKENS VIEW" },
  { id: "impact", label: "IMPACT VIEW" },
  { id: "achievements", label: "ACHIEVEMENTS VIEW" },
]

export function StatsTabs() {
  const [activeTab, setActiveTab] = useState<TabId>("stats")
  const [purchaseCount, setPurchaseCount] = useState<number>(0)
  const [tokens, setTokens] = useState<number>(0)
  const [salesCount, setSalesCount] = useState<number>(0)
  const [userImpact, setUserImpact] = useState<UserImpact>({
    co2_saved_kg: 0,
    landfill_reduced_kg: 0,
    water_saved_liters: 0,
  })

useEffect(() => {
  const fetchData = async () => {
    const user = await retrieveCustomer()
    if (!user) return

    const userTokens = await getTokens(user.email)
    setTokens(userTokens)

    const impact = await getUserImpactByEmail(user.email)
    setUserImpact(impact)

    const purchases = await getPurchasesByEmail(user.email)
    setPurchaseCount(purchases)

    const sales = await getSalesByEmail(user.email)
    setSalesCount(sales)
  }

  fetchData()
}, [])


  const achievements = [
    {
      title: "Welcome to ReFashion",
      description: "Create your account on ReFashion",
      image: "/images/achievements/refashion.png",
      progress: 1,
      total: 1,
    },
    {
      title: "First Sale",
      description: "Sell your first item on ReFashion",
      image: "/images/achievements/1st-sell.png",
      progress: Math.min(salesCount,1),
      total: 1,
    },
    {
      title: "First Purchase",
      description: "Buy your first secondhand item",
      image: "/images/achievements/1st-buy.png",
      progress: Math.min(purchaseCount,1),
      total: 1,
    },
    {
      title: "Consistent Seller",
      description: "Complete 5 sales",
      image: "/images/achievements/con-seller.png",
      progress: Math.min(salesCount,5),
      total: 5,
    },
    {
      title: "Consistent Buyer",
      description: "Complete 5 purchases",
      image: "/images/achievements/con-buyer.png",
      progress: Math.min(purchaseCount,5),
      total: 5,
    },
    {
      title: "Super Seller",
      description: "Complete 10 sales",
      image: "/images/achievements/super-seller.png",
      progress: Math.min(salesCount,10),
      total: 10,
    },
    {
      title: "Super Buyer",
      description: "Complete 10 purchases",
      image: "/images/achievements/super-buyer.png",
      progress: Math.min(purchaseCount,10),
      total: 10,
    },
    {
      title: "Vintage Ambassador",
      description: "List 5 vintage items",
      image: "/images/achievements/vintage.png",
      progress: 0,
      total: 5,
    },
    {
      title: "Personal Impact",
      description:
        "Reached 5 kg CO2 , 500 Lt water, or 10 kg landfill savings.",
      image: "/images/achievements/personal-impact.png",
      progress: 0,
      total: 3,
    },
    {
      title: "One of a Kind",
      description:
        "Listed 3 premium items with proof of authenticity and original packaging.",
      image: "/images/achievements/one-of-a-kind.png",
      progress: 1,
      total: 3,
    },
    {
      title: "ReFashion Star",
      description: "Received 50 hearts from fellow fashion lovers.",
      image: "/images/achievements/refashion-star.png",
      progress: 50,
      total: 50,
    },
  ]

  const completedAchievementsCount = achievements.filter(
    (a) => a.progress >= a.total
  ).length

  return (
    <div className="flex flex-col gap-4">
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

      <div className="rounded-md border border-gray-200 p-4">
        {activeTab === "stats" && (
          <div className="space-y-4">
            <p className="text-sm text-gray-600">
              A high-level snapshot of your circular fashion impact, combining
              Tokens, Sustainability Impact and Achievements.
            </p>

            <div className="grid gap-4 md:grid-cols-3">
              <button
                type="button"
                onClick={() => setActiveTab("tokens")}
                className="flex flex-col rounded-xl border border-gray-200 p-4 text-left hover:shadow-sm transition-shadow"
              >
                <div className="mb-3">
                  <h3 className="text-base font-semibold">My Tokens</h3>
                </div>
                <div className="flex flex-1 flex-col items-center justify-center gap-2">
                  <div className="flex h-20 w-20 items-center justify-center rounded-full bg-violet-50">
                    <TokensIcon className="h-14 w-14 text-violet-500" />
                  </div>
                  <p className="mt-1 text-3xl font-bold">{tokens} RFT</p>
                  <p className="text-xs text-gray-500">
                    Your current balance
                  </p>
                </div>
                <div className="mt-3 flex items-center justify-end">
                  <span className="text-lg text-gray-400">{">"}</span>
                </div>
              </button>

              <button
                type="button"
                onClick={() => setActiveTab("impact")}
                className="flex flex-col rounded-xl border border-gray-200 p-4 text-left hover:shadow-sm transition-shadow"
              >
                <div className="mb-3">
                  <h3 className="text-base font-semibold">My Impact</h3>
                </div>
                <div className="flex flex-1 flex-col items-center justify-center gap-3">
                  <div className="flex h-20 w-20 items-center justify-center rounded-full bg-violet-50">
                    <ImpactIcon className="h-14 w-14 text-violet-500" />
                  </div>
                  <div className="flex w-full items-end justify-between gap-3">
                    <div className="flex flex-col items-center gap-1 text-center">
                      <CO2Icon className="h-8 w-8 text-violet-400" />
                      <p className="text-lg font-bold">{Math.trunc(userImpact.co2_saved_kg)} kg</p>
                      <p className="text-[11px] text-gray-500 leading-tight">
                        CO₂ <br /> saved
                      </p>
                    </div>
                    <div className="flex flex-col items-center gap-1 text-center">
                      <WaterIcon className="h-8 w-8 text-violet-400" />
                      <p className="text-lg font-bold">{Math.trunc(userImpact.water_saved_liters)} lt</p>
                      <p className="text-[11px] text-gray-500 leading-tight">
                        Water <br /> saved
                      </p>
                    </div>
                    <div className="flex flex-col items-center gap-1 text-center">
                      <LandfillIcon className="h-8 w-8 text-violet-400" />
                      <p className="text-lg font-bold">{Math.trunc(userImpact.landfill_reduced_kg)} kg</p>
                      <p className="text-[11px] text-gray-500 leading-tight">
                        Landfill <br /> reduced
                      </p>
                    </div>
                  </div>
                </div>
                <div className="mt-3 flex items-center justify-end">
                  <span className="text-lg text-gray-400">{">"}</span>
                </div>
              </button>

              <button
                type="button"
                onClick={() => setActiveTab("achievements")}
                className="flex flex-col rounded-xl border border-gray-200 p-4 text-left hover:shadow-sm transition-shadow"
              >
                <div className="mb-3">
                  <h3 className="text-base font-semibold">My Achievements</h3>
                </div>
                <div className="flex flex-1 flex-col items-center justify-center gap-2">
                  <div className="flex h-20 w-20 items-center justify-center rounded-full bg-violet-50">
                    <AchievementsIcon className="h-14 w-14 text-violet-500" />
                  </div>
                  <p className="mt-1 text-3xl font-bold">
                    {completedAchievementsCount}
                  </p>
                  <p className="text-xs text-gray-500">Badges</p>
                </div>
                <div className="mt-3 flex items-center justify-end">
                  <span className="text-lg text-gray-400">{">"}</span>
                </div>
              </button>
            </div>
          </div>
        )}

        {activeTab === "impact" && (
  <div className="space-y-6">
    
    <div>
      <h2 className="text-lg font-semibold">My Impact</h2>
      <p className="text-sm text-gray-600">
        A summary of your circular fashion efforts. See how much CO₂, water, and landfill you've saved!
      </p>
    </div>

    
    <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
      <div className="flex flex-col items-center rounded-xl border border-gray-200 p-4">
        <CO2Icon className="h-10 w-10 text-violet-400 mb-2" />
        <p className="text-2xl font-bold">{Math.trunc(userImpact.co2_saved_kg)} kg</p>
        <p className="text-xs text-gray-500 text-center">
          CO₂ saved • Top {Math.floor(Math.random() * 50 + 50)}%
        </p>
      </div>
      <div className="flex flex-col items-center rounded-xl border border-gray-200 p-4">
        <WaterIcon className="h-10 w-10 text-violet-400 mb-2" />
        <p className="text-2xl font-bold">{Math.trunc(userImpact.water_saved_liters)} lt</p>
        <p className="text-xs text-gray-500 text-center">
          Water saved • Top {Math.floor(Math.random() * 50 + 50)}%
        </p>
      </div>
      <div className="flex flex-col items-center rounded-xl border border-gray-200 p-4">
        <LandfillIcon className="h-10 w-10 text-violet-400 mb-2" />
        <p className="text-2xl font-bold">{Math.trunc(userImpact.landfill_reduced_kg)} kg</p>
        <p className="text-xs text-gray-500 text-center">
          Landfill reduced • Top {Math.floor(Math.random() * 50 + 50)}%
        </p>
      </div>
    </div>

    
    <div className="space-y-4">
      <h3 className="text-md font-semibold">Fun Facts</h3>
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div className="rounded-xl border border-gray-200 p-4 bg-violet-50">
          <p className="text-sm text-gray-700">
            By saving {Math.trunc(userImpact.co2_saved_kg)} kg of CO₂, you could power a small home for 2 months!
          </p>
        </div>
        <div className="rounded-xl border border-gray-200 p-4 bg-violet-50">
          <p className="text-sm text-gray-700">
            Your {Math.trunc(userImpact.water_saved_liters)} liters of water saved could fill 5 swimming pools!
          </p>
        </div>
        <div className="rounded-xl border border-gray-200 p-4 bg-violet-50">
          <p className="text-sm text-gray-700">
            Reducing {Math.trunc(userImpact.landfill_reduced_kg)} kg of landfill is like removing 3 cars from the road!
          </p>
        </div>
      </div>
    </div>
  </div>
)}


        {activeTab === "tokens" && (
          <div>
            <h2 className="label-md mb-2">Tokens</h2>
            <p className="mb-6 text-sm text-gray-600">
              Keep track on your ReFashion Tokens and exchange them for real life
              rewards.
            </p>

            <div className="grid gap-4 md:grid-cols-2">
              <div className="rounded-xl border border-gray-200 p-6 flex flex-col justify-between">
                <div className="flex flex-col items-center justify-center flex-1">
                  <div className="relative">
                    <svg width="220" height="130" viewBox="0 0 220 130">
                      <path
                        d="M30 110 A80 80 0 0 1 190 110"
                        fill="none"
                        stroke="#e5e7eb"
                        strokeWidth="12"
                      />
                      <path
                        d="M30 110 A80 80 0 0 1 190 110"
                        fill="none"
                        stroke="#8b5cf6"
                        strokeWidth="12"
                        strokeLinecap="round"
                        strokeDasharray={Math.PI * 80}
                        strokeDashoffset={
                          Math.PI * 80 * (1 - Math.min(tokens / 500, 1))
                        }
                      />
                    </svg>

                    <div className="absolute inset-0 flex items-center justify-center pt-6">
                      <span className="text-4xl font-semibold text-gray-900">
                        {tokens}
                        <span className="ml-1 text-lg font-medium text-gray-500">
                          RFT
                        </span>
                      </span>
                    </div>
                  </div>

                  <p className="mt-4 text-sm text-gray-600 text-center">
                    {tokens >= 500
                      ? "Reward unlocked."
                      : `${500 - tokens} tokens left to reach your next reward.`}
                  </p>
                </div>
              </div>

              <div className="rounded-xl border border-gray-200 p-6">
                <h3 className="mb-4 text-sm font-semibold text-gray-900">
                  Latest Token Gains
                </h3>

                <ul className="space-y-4">
                  <li className="flex items-center justify-between text-sm">
                    <span className="text-gray-600">Purchase</span>
                    <span className="font-semibold text-green-500">
                      +170 RFT
                    </span>
                  </li>
                  <li className="flex items-center justify-between text-sm">
                    <span className="text-gray-600">Purchase</span>
                    <span className="font-semibold text-green-500">
                      +130 RFT
                    </span>
                  </li>
                  <li className="flex items-center justify-between text-sm">
                    <span className="text-gray-600">
                      Redeem 10% discount
                    </span>
                    <span className="font-semibold text-red-500">
                      -100 RFT
                    </span>
                  </li>
                  <li className="flex items-center justify-between text-sm">
                    <span className="text-gray-600">Sale</span>
                    <span className="font-semibold text-green-500">
                      +100 RFT
                    </span>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        )}

        {activeTab === "achievements" && (
          <div>
            <h2 className="label-md mb-2">Achievements</h2>
            <p className="mb-4 text-sm text-gray-600">
              Badges, levels and milestones you've unlocked through your
              activity.
            </p>

            <div className="grid gap-4 md:grid-cols-2">
              {achievements.map((achievement) => (
                <AchievementCard
                  key={achievement.title}
                  {...achievement}
                />
              ))}
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
