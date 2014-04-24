
require 'beer_bash/beer_menus'
require 'beer_bash/version'
require 'mechanize'
require 'terminal-table'

module BeerBash
  class << self
    def on_tap_at(name)
      places = BeerMenus::Place.search(name)
      place  = choose_place(places) or raise "Sorry, I couldn't find a place called #{name}"
      print(place)
    end

    private

      def choose_place(places)
        if places.size == 1
          places.first
        elsif places.size > 1
          choose("\n** Which one of these did you have in mind?\n\n", *places)
        end
      end

      def print(place)
        tap_list = place.on_tap

        table = Terminal::Table.new do |t|
          t.title    = "#{place} * Updated #{format_date(tap_list.updated_at)}"
          t.headings = %w(Beer ABV Format Price)
          t.rows     = tap_list.taps.collect {|beer| [beer.name, beer.abv, beer.format, beer.price]}
          (1..3).each {|idx| t.align_column(idx, :right)}
        end

        puts table
      end

      def format_date(date)
        days_ago = (Date.today - date).to_i
        case days_ago
        when 0 then 'Today!'
        when 1 then 'Yesterday'
        when 2 then 'a Couple Days Ago'
        when 3 then 'a Few Days Ago'
        when 4..6 then "#{days_ago} Days Ago"
        when 7 then 'a Week Ago'
        else "Waaay Back on #{date.strftime('%m/%d/%Y')}"
        end
      end
  end
end
