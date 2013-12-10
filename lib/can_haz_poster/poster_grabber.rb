require 'open-uri'
require 'net/http'
require 'nokogiri'

module CanHazPoster
  class PosterGrabber
    SERVICE_HOST = "http://www.movieposterdb.com"
    SEARCH_PATH = "/search/?query=%{query}"

    def grab_poster(title, year)
      movie_url = parse_movie_url(fetch_search_results(title), year)
      parse_poster_url(fetch_movie_page(movie_url))
    end

  private

    def fetch_search_results(title)
      open(SERVICE_HOST + SEARCH_PATH % {query: URI.encode_www_form_component(title)})
    end

    def fetch_movie_page(url)
      open(url)
    end

    def parse_movie_url(page, year)
      doc = Nokogiri::HTML(page)
      cell = doc.css('.content td:nth-child(2)').find do |cell|
        year_span = cell.css('span b').first
        year_span && year_span.content == year.to_s
      end

      raise MovieNotFoundError if cell.nil?

      SERVICE_HOST + cell.css('a').first['href']
    end

    def parse_poster_url(page)
      doc = Nokogiri::HTML(page)
      doc.css('.poster a > img').first['data-original']
    end
  end
end
