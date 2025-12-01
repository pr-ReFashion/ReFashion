import Parser from "rss-parser"
import { BlogCard } from "@/components/organisms"
import { BlogPost } from "@/types/blog"

// Helper: extract first image URL from HTML
function extractImage(html?: string): string | null {
  if (!html) return null
  const imgRegex = /<img[^>]+src=["']([^"']+)["']/i
  const match = html.match(imgRegex)
  return match ? match[1] : null
}

export async function BlogSection() {
  const parser = new Parser({
    customFields: {
      item: ["content:encoded"],
    },
  })

  // Replace with your RSS feed URL
  const feed = await parser.parseURL("https://www.eco-stylist.com/feed/")

  // Sort items by pubDate descending (newest first)
  const sortedItems = feed.items
    .slice()
    .sort((a, b) => {
      const dateA = new Date(a.pubDate || 0).getTime()
      const dateB = new Date(b.pubDate || 0).getTime()
      return dateB - dateA
    })
    .slice(0, 3) // take only 3 latest articles

  const blogPosts: BlogPost[] = sortedItems.map((item, index) => {
    const enclosureImage = item.enclosure?.url
    const htmlContent =
      (item as any)["content:encoded"] || item.content || item.contentSnippet
    const extractedImage = extractImage(htmlContent)
    const finalImage = enclosureImage || extractedImage || "/images/blog/default.jpg"

    return {
      id: index,
      title: item.title ?? "Untitled",
      excerpt: item.contentSnippet ?? "",
      image: finalImage,
      category: item.categories?.[0] ?? "NEWS",
      href: item.link ?? "#",
    }
  })

  return (
    <section className="bg-tertiary container">
      <div className="flex items-center justify-between mb-12">
        <h2 className="heading-lg text-tertiary">STAY UP TO DATE</h2>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {blogPosts.map((post, index) => (
          <BlogCard key={post.id} index={index} post={post} />
        ))}
      </div>
    </section>
  )
}
