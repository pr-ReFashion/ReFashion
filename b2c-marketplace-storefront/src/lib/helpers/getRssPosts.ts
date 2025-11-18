import Parser from "rss-parser"
import * as cheerio from "cheerio"

const parser = new Parser()

// Normalize and validate image URLs
function normalizeImageUrl(url?: string | null): string {
  if (!url) return "/images/blog/default.jpg"

  try {
    const decoded = decodeURIComponent(url.replace(/&amp;/g, "&"))

    const isAbsolute = /^https?:\/\//.test(decoded)
    if (!isAbsolute) return "/images/blog/default.jpg"

    return decoded
  } catch {
    return "/images/blog/default.jpg"
  }
}

export async function getRssPosts() {
  const feedUrl = "YOUR_RSS_FEED_URL_HERE"

  const feed = await parser.parseURL(feedUrl)

  return feed.items.map((item, index) => {
    const html =
      (item["content:encoded"] as string) ||
      item.content ||
      item.summary ||
      ""

    const $ = cheerio.load(html)

    // 1) Try to extract <img src="">
    let image = $("img").attr("src") || null

    // 2) Try enclosure-based image
    if (!image && item.enclosure?.url) {
      image = item.enclosure.url
    }

    // 3) Final sanitized image
    const safeImage = normalizeImageUrl(image)

    return {
      id: index + 1,
      title: item.title || "Untitled",
      excerpt: item.contentSnippet || "",
      image: safeImage,
      category: item.categories?.[0] || "NEWS",
      href: item.link || "#",
    }
  })
}
