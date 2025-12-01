"use client";

import { useState, useEffect } from "react";
import Image from "next/image";

const sections = [
  {
    id: "general-information",
    label: "General Information",
    image: "/images/about_us/1.jpg",
    content:
      "ReFashion is a research project that aims to strengthen the circular economy in the fashion sector by developing an integrated resale platform based on Blockchain technology. Through the platform, citizens and businesses can reuse, exchange, sell, or donate second-hand fashion products (clothing and footwear), thereby reducing the environmental impact of overconsumption. The platform will consist of three main subsystems: a data collection subsystem that gathers real-time data (photos and item descriptions) for visualization; a reward subsystem based on a Blockchain platform that tokenizes the buying and selling of products; and an application subsystem that visualizes both the collected information and the generated knowledge, providing the foundation for offering enriched, value-added services to all users.",
  },
  {
    id: "the-issue",
    label: "The Issue",
    image: "/images/about_us/2.jpg",
    content:
      "The fashion industry is among the most polluting worldwide, responsible for enormous amounts of waste, water consumption, and CO2 emissions, with Greece in fact ranking among the countries with the highest levels of per-capita water consumption in this sector. Every year, millions of tons of clothing are discarded in landfills, with only a small percentage being recycled or reused. The culture of ‘fast fashion’ exacerbates the situation, promoting short production cycles and overconsumption (Niinimäki et al., 2020). At the same time, the lack of organized tools for traceability and the exchange of second-hand items makes it difficult to transition to a more sustainable model—something the ReFashion platform aims to address.",
  },
  {
    id: "project-goals",
    label: "Project Goals",
    image: "/images/about_us/4.png",
    content: `The ReFashion project aims to address the above challenges through the creation of a digital platform that will support the reuse of fashion products in an innovative, technologically advanced way. Specifically, in the long term, the objectives of the proposed project are:

- To facilitate the implementation of the Waste Framework Directive, which aims to reduce waste production and promote recycling and reuse. Through the use of Blockchain, unprecedented transparency and traceability of transactions is offered, which can significantly improve the efficiency of recycling processes and material recovery in the fashion sector.

- To promote environmental sustainability in the EU by encouraging sustainable consumption and production, in line with the goals of the European Green Deal for reducing CO2 emissions.

- To contribute to achieving the goals of the Fashion Pact, which aims to enhance sustainability in the fashion industry while reducing waste and promoting the circular economy.

- To strengthen the objectives of the European Union’s strategy “For Sustainable and Circular Textiles” for the green transition of the ecosystem, according to which by 2030, textile products placed on the EU market will be durable, recyclable, and largely made from harmless and recyclable materials.

- To develop and promote local chains for the reuse of second-hand fashion products, enabling significant profit for sellers and reducing the cost of purchasing new products, creating a new revenue stream and giving value to items previously considered waste.

- To develop the ReFashion platform through the application of its results in such a way as to expand its network of users and partners both domestically and globally, establishing the platform as a hub of innovation and sustainability.`,
  },
  {
    id: "research-methodology",
    label: "Research Methodology",
    image: "/images/about_us/3.jpg",
    content: `The ReFashion research methodology focuses on two main axes to achieve the expected results:

- Waste management in the fashion sector, transforming clothing and accessories that were previously useless to one user into useful items in the hands of another user.

- Blockchain technology, through which transactions between sellers and buyers will be recorded and validated, creating a climate of trust. At the same time, the Blockchain technology will provide users with tokens as an additional incentive for more users to join the platform.`,
  },
  {
    id: "expected-results",
    label: "Expected Results",
    image: "/images/about_us/5.jpg",
    content:
      "Upon its completion, the ReFashion project is expected to offer a fully functional and user-friendly digital tool that will facilitate the reuse of second-hand fashion products. The outcomes include reducing waste ending up in landfills, increasing citizens’ environmental awareness, promoting sustainable consumption, creating new local economies around second-hand fashion, and generating know-how that can be applied to other sectors. Additionally, the project aims to evolve into a reference point for sustainable innovation in Europe.",
  },
];

// ------------------------------------------
// SECTION COMPONENT
// ------------------------------------------
function SectionBlock({ section, index }) {
  const { id, label, content, image } = section;
  const hasImage = image && image.trim() !== "";

  return (
    <div
      id={id}
      className="rounded-2xl p-10 scroll-mt-32 space-y-6"
      style={{
        backgroundColor: `rgb(var(--neutral-0))`,
        border: hasImage ? `1px solid rgb(var(--neutral-100))` : "none",
        boxShadow: hasImage ? "0 4px 12px rgba(0,0,0,0.05)" : "none",
      }}
    >
      <h2
        className="text-3xl font-semibold mb-4"
        style={{ color: `rgb(var(--brand-600))` }}
      >
        {label}
      </h2>

      {/* IMAGE + CONTENT Layout */}
      {hasImage ? (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8 items-center">
          {index % 2 === 0 ? (
            <>
              <ImageBlock src={image} alt={label} />
              <ContentBlock content={content} />
            </>
          ) : (
            <>
              <ContentBlock content={content} />
              <ImageBlock src={image} alt={label} />
            </>
          )}
        </div>
      ) : (
        <ContentBlock content={content} />
      )}
    </div>
  );
}

// ------------------------------------------
// SUB COMPONENTS
// ------------------------------------------
function ImageBlock({ src, alt }) {
  return (
    <div className="w-full relative rounded-2xl overflow-hidden shadow-md aspect-[4/3]">
      <Image src={src} alt={alt} fill className="object-cover" />
    </div>
  );
}

function ContentBlock({ content }) {
  return (
    <p
      className="leading-relaxed text-lg whitespace-pre-line"
      style={{ color: `rgb(var(--neutral-700))` }}
    >
      {content || "Write your content here…"}
    </p>
  );
}

// ------------------------------------------
// MAIN PAGE COMPONENT
// ------------------------------------------
export default function AboutPage() {
  const [active, setActive] = useState("general-information");

  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        const visible = entries.filter((e) => e.isIntersecting);
        if (visible.length > 0) {
          const top = visible.reduce((prev, curr) =>
            prev.boundingClientRect.top < curr.boundingClientRect.top ? prev : curr
          );
          setActive(top.target.id);
        }
      },
      { threshold: 0.4 }
    );

    sections.forEach((s) => {
      const el = document.getElementById(s.id);
      if (el) observer.observe(el);
    });

    return () => observer.disconnect();
  }, []);

  return (
    <main
      className="flex container mx-auto mt-20"
      style={{ backgroundColor: `rgb(var(--neutral-0))` }}
    >
      {/* SIDEBAR */}
      <aside
        className="w-64 p-6 space-y-4 sticky top-20 self-start"
        style={{
          backgroundColor: `rgb(var(--neutral-25))`,
          borderRight: `1px solid rgb(var(--neutral-100))`,
        }}
      >
        <h2
          className="text-xl font-semibold mb-4"
          style={{ color: `rgb(var(--brand-600))` }}
        >
          Contents
        </h2>

        <nav className="space-y-2">
          {sections.map((s) => (
            <a
              key={s.id}
              href={`#${s.id}`}
              className="block px-3 py-2 rounded-lg transition-all"
              style={{
                backgroundColor:
                  active === s.id ? `rgb(var(--brand-600))` : "transparent",
                color:
                  active === s.id
                    ? `rgb(var(--neutral-0))`
                    : `rgb(var(--neutral-700))`,
                fontWeight: active === s.id ? 600 : 400,
                border:
                  active === s.id
                    ? `1px solid rgb(var(--brand-300))`
                    : "1px solid transparent",
              }}
            >
              {s.label}
            </a>
          ))}
        </nav>
      </aside>

      {/* MAIN CONTENT */}
      <section className="flex-1 ml-64 p-14 space-y-32">
        {sections.map((section, index) => (
          <SectionBlock key={section.id} section={section} index={index} />
        ))}
      </section>
    </main>
  );
}
