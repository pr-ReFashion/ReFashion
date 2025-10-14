import React from "react"

const FOOTER_LINKS = [
  { text: "ΕΜΠ-ΕΕΕΕ", url: "https://orlog.simor.ntua.gr/" }, 
  { text: "Neotextile", url: "https://neotextile.eco/" },
  { text: "ΠΑ.ΠΕΛ", url: "http://disyd-lab.ece.uop.gr/" },
  { text: "CYCLEFI", url: "https://cyclefi.com/" },
  { text: "ΕΚΑΝ", url: "https://ekanrecycling.gr/" },
];

export function Footer() {
  return (
    <div className="w-full font-roboto">
      
      <footer
        className="w-full bg-cover bg-center text-white"
        style={{ backgroundImage: `url('/background.png')` }}
      >
        <div className="container mx-auto">
          
          <div className="flex flex-col lg:flex-row items-center justify-between p-8 md:p-12">

            {/* Image Column */}
            <div className="flex flex-col justify-center mb-6 lg:mb-0">
              <img
                src="/NextGen.png"
                alt="ReFashion Logo"
                className="max-w-xs lg:max-w-sm h-auto mx-auto lg:mx-0 object-contain"
              />
            </div>

            {/* Quick Links Column */}
            <div className="px-4 lg:px-0 text-center lg:text-left">
              <h2 className="text-xl font-semibold mb-4 uppercase text-white">
                Quick Links
              </h2>
              <nav className="flex flex-col space-y-3 text-sm lg:text-base">
                {FOOTER_LINKS.map((link) => (
                  <a 
                    key={link.text}
                    href={link.url} 
                    className="cursor-pointer hover:text-gray-300 transition-colors"
                  >
                    {link.text}
                  </a>
                ))}
              </nav>
            </div>

          </div>
          
        </div>
      </footer>
      
      <div className="bg-white text-black w-full"> 
        <div className="container mx-auto flex flex-col md:flex-row items-center justify-between py-2 px-4">
            
            <p className="text-sm text-center md:text-left text-gray-700 flex-1 order-2 md:order-1 mt-2 md:mt-0">
              Η δράση υλοποιείται στο πλαίσιο του Εθνικού Σχεδίου Ανάκαμψης και Ανθεκτικότητας Ελλάδα 2.0 με τη χρηματοδότηση της Ευρωπαικής Ένωσης NextGenerationEU
            </p>

            <div className="flex justify-center space-x-4 order-1 md:order-2">
              
              <a href="https://x.com/refashion_eu" target="_blank" rel="noopener noreferrer" className="text-gray-700 hover:text-black transition-colors">
                <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                  <path d="M18.901 1.127H23.951L15.892 9.456L24 22.882H17.844L12.448 15.656L6.502 22.882H1L9.438 14.128L1 1.127H6.162L10.596 7.427L17.514 1.127H18.901ZM18.571 20.375L19.988 20.375L7.545 3.321L6.071 3.321L18.571 20.375Z" />
                </svg>
              </a>

              <a href="https://www.linkedin.com/company/refashion-eu" target="_blank" rel="noopener noreferrer" className="text-gray-700 hover:text-black transition-colors">
                <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                  <path d="M19 0h-14c-2.761 0-5 2.239-5 5v14c0 2.761 2.239 5 5 5h14c2.762 0 5-2.239 5-5v-14c0-2.761-2.238-5-5-5zm-11 19h-3v-11h3v11zm12 0h-3v-5.604c0-3.368-4-3.113-4 0v5.604h-3v-11h3v1.765c1.396-2.586 7-2.777 7 2.476v6.759z"/>
                </svg>
              </a>
              
            </div>
        </div>
      </div>
      
    </div>
  )
}

