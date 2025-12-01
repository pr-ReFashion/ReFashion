import { Carousel } from "@/components/cells"
import { CategoryCard } from "@/components/organisms"

export const categories: { id: number; name: string; handle: string }[] = [
  {
    id: 1,
    name: "Casual Shoes",
    handle: "casual shoes",
  },
  {
    id: 2,
    name: "Sandals & Slides",
    handle: "sandals & slides",
  },
  {
    id: 3,
    name: "Formal & Dress Shoes",
    handle: "formal & dress shoes",
  },
  {
    id: 4,
    name: "All Shoes",
    handle: "all shoes",
  },
  {
    id: 5,
    name: "Headwear & Scarves",
    handle: "headwear & scarves",
  },
]

export const HomeCategories = async ({ heading }: { heading: string }) => {
  return (
    <section className="bg-primary py-8 w-full">
      <div className="mb-6">
        <h2 className="heading-lg text-primary uppercase">{heading}</h2>
      </div>
      <Carousel
        items={categories?.map((category) => (
          <CategoryCard key={category.id} category={category} />
        ))}
      />
    </section>
  )
}
