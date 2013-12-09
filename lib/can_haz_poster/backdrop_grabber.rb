require 'open-uri'
require 'net/http'
require 'nokogiri'

module CanHazPoster
  class BackdropGrabber
    SERVICE_HOST = 'https://www.themoviedb.org'
    SEARCH_PATH = '/search?query=%{query}'
    BACKDROP_PATH = '/images?kind=backdrop'
    
    def grab_backdrop(title, year)
      movie_url = parse_movie_url(fetch_search_results(title), year)
      parse_backdrop_url(movie_url)
    end

    private

    def fetch_search_results(title)
      open(SERVICE_HOST + SEARCH_PATH % {query: URI.encode_www_form_component(title)})
    end

    def parse_movie_url(page, year)
      doc = Nokogiri::HTML(page)
      cell = doc.css('.search_results.movie .info').find do |cell|
        year_span = cell.css('h3 > span').first.text.delete"()"
        year_span == year.to_s
      end

      raise MovieNotFoundError if cell.nil?

      SERVICE_HOST + cell.css('h3 > a').first['href'] + BACKDROP_PATH
    end

    def parse_backdrop_url(page)
      doc = Nokogiri::HTML(open(page))                                                                   
      backdrop_arr = []
      doc.css('#backdrops .delete').each do |link|
        backdrop_arr << link.css('a.lightbox').attr('href').text
      end
      backdrop_arr
    end
  end
end
