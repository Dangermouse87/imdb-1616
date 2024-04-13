# Create a method to get the top 5 urls from https://www.imdb.com/chart/top/
require "open-uri"
require "nokogiri"

def scrape_top_5_urls
  # 1 - define url
  url = "https://gist.githubusercontent.com/yannklein/2fafc4287db6967d4b27b0e4dc4d1416/raw/43d378abcebeb28a2f8ec1ff7dda5961c935edd7/IMDB.html"
  # 2 - open url
  html_doc = URI.open(url).read
  # 3 - parse the data
  html_file = Nokogiri::HTML.parse(html_doc)
  # 4 - scrape the website
  html_file.search(".ipc-title-link-wrapper").first(5).map do |element|
    "https://www.imdb.com#{element.attribute("href").value.split("?").first}"
  end
  # 5 - return the result as an array
end

# Create a method to scrape movie data from a specific movie page (ex. https://www.imdb.com/title/tt0111161/) - Title, Director, Cast, Year, Storyline, Rating

# puts scrape_top_5_urls

def scrape_movie(url)
  html_doc = URI.open(url, 'Accept-Language' => 'en', "User-Agent" => "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:89.0)").read
  doc = Nokogiri::HTML.parse(html_doc)

  cast =  doc.search('.sc-bfec09a1-1.gCQkeh').map { |x| x.text.strip }[..2]
  rating = doc.search('.cMEQkK').first.text.to_f
  title = doc.search('.hero__primary-text').text.strip
  director = doc.search('.ipc-metadata-list-item__list-content-item.ipc-metadata-list-item__list-content-item--link').first.text.strip
  year =  doc.search('li.ipc-inline-list__item a.ipc-link.ipc-link--baseAlt.ipc-link--inherit-color')[4].text.strip.to_i
  storyline = doc.search(".sc-466bb6c-0").text.strip

  {
    cast: cast,
    rating: rating,
    title: title,
    director: director,
    year: year,
    storyline: storyline
    }

end

p scrape_movie("https://www.imdb.com/title/tt0111161/")
