require 'open-uri'
require 'net/http'
require 'nokogiri'

module CanHazPoster
  class BackdropGrabber
    SERVICE_HOST  = 'https://www.themoviedb.org'
    SEARCH_PATH   = '/search?query=%{query}'
    BACKDROP_PATH = '/images?kind=backdrop'

    def grab_backdrops(title, year)
      movie_url = parse_movie_url(fetch_search_results(title), year)
      parse_backdrop_urls(movie_url)
    end

    private

    def fetch_search_results(title)
      open(SERVICE_HOST + SEARCH_PATH % {query: URI.encode_www_form_component(title)})
    end

    def parse_movie_url(page, year)
      doc = Nokogiri::HTML(page)
      cell = doc.css('.search_results.movie .info').find do |cell|
        year_node = cell.at_css('h3 > span')
        year_node && year_node.text.delete("()") == year.to_s
      end

      raise MovieNotFoundError if cell.nil?

      SERVICE_HOST + cell.at_css('h3 > a')['href'] + BACKDROP_PATH
    end

    def parse_backdrop_urls(page)
      doc = Nokogiri::HTML(open(page))
      doc.css('#backdrops .image a').map {|link| link['href'] }
    end
  end
end
