import type { Metadata } from "next"
import { Funnel_Display } from "next/font/google"
import "./globals.css"

const funnelDisplay = Funnel_Display({
  variable: "--font-funnel-sans",
  subsets: ["latin"],
  weight: ["300", "400", "500", "600"],
})

export const metadata: Metadata = {
  title: {
    template: `%s | ReFashion - Sustainable Fashion Marketplace`,
    default: `ReFashion - Sustainable Fashion Marketplace`,
  },
  description: "Buy and sell second-hand fashion sustainably",
  metadataBase: new URL(process.env.NEXT_PUBLIC_BASE_URL || "http://localhost:3000"),
}


export default async function RootLayout({
                                           children,
                                           params,
                                         }: Readonly<{
  children: React.ReactNode
  params: Promise<{ locale: string }>
}>) {
  const { locale } = await params
  return (
      <html lang={locale} className="">
      <body
          className={`${funnelDisplay.className} antialiased bg-primary text-secondary`}
      >
      {children}
      </body>
      </html>
  )
}
