module BeerBash
  module BeerMenus

    class Place
      def self.search(name)
        Scraper.new.places(name)
      end

      attr_reader :name, :path

      def initialize(name, path)
        @name = name
        @path = path
      end

      def on_tap
        Scraper.new.taps(path)
      end

      def to_s
        name
      end
    end

    TapList = Struct.new(:updated_at, :taps)

    Beer = Struct.new(:name, :abv, :format, :price) do
      def on_tap?
        format =~ /draft|cask|growler/i
      end
    end

    class Scraper
      BASE_URL = 'http://www.beermenus.com'

      def places(name)
        page = scrape(places_url(name))
        links = page.links_with(href: %r"/places/\d+-") # like /places/12-some-place
        links.collect {|link| Place.new(link.to_s, link.href)}
      end

      def taps(place_path)
        page = scrape(taps_url(place_path))
        TapList.new(find_updated(page), find_taps(page))
      end

      private

        def agent
          @agent ||= Mechanize.new
        end

        def scrape(url)
          agent.get(url)
        end

        def places_url(place_name)
          URI.escape("#{BASE_URL}/search?q=#{place_name}")
        end

        def taps_url(place_path)
          URI.escape("#{BASE_URL}/#{place_path}")
        end

        def find_updated(page)
          page.search('//div[contains(@class,"content")]/p[contains(text(),"Updated: ")]')
              .first.text.strip.match(/Updated: (.*)/)[1] rescue '???'
        end

        def find_taps(page)
          page.search('//table[contains(@class,"beermenu")]/tbody/tr').each_with_object([]) do |row, beers|
            next unless row.element_children.size == 4 # some rows are for a description

            name   = row.at('td[1]').text.strip
            abv    = row.at('td[2]').text.strip
            format = row.at('td[3]').text.strip
            price  = row.at('td[4]').text.strip
            beer   = Beer.new(name, abv, format, price)
            beers  << beer if beer.on_tap?
          end
        end
    end
  end
end
