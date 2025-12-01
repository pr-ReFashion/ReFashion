"use client"

import Image from "next/image"
import React from "react"

export default function AchievementCard({
    title,
    description,
    image,
    progress = 0,
    total = 1,
}: {
    title: string
    description: string
    image: string
    progress?: number
    total?: number
}) {
    const percentage = Math.min(progress / total, 1) * 100
    const isComplete = progress >= total

    return (
        <div className="flex flex-col gap-4 rounded-xl border border-gray-200 p-4 shadow-sm hover:shadow transition-shadow">
            <div className="flex items-center gap-3">
                <div className="flex h-20 w-20 items-center justify-center rounded-full bg-violet-50">
                    <Image
                        src={image}
                        alt={title}
                        width={120}
                        height={120}
                        className="object-contain"
                        unoptimized
                    />
                </div>

                <div>
                    <h3 className="text-base font-semibold">{title}</h3>
                    <p className="text-xs text-gray-500">{description}</p>
                </div>
            </div>

            <div className="flex flex-col gap-1">
                <div className="h-2 w-full rounded-full bg-gray-200 overflow-hidden">
                    <div
                        className={`h-full rounded-full transition-all ${
                            isComplete ? "bg-green-500" : "bg-violet-500"
                        }`}
                        style={{ width: `${percentage}%` }}
                    ></div>
                </div>

                <p className="text-xs text-gray-600">
                    {progress} / {total} {isComplete && "✓ Completed"}
                </p>
            </div>
        </div>
    )
}
