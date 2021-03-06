require 'open-uri'
require 'net/http'
require 'nokogiri'

module CanHazPoster
  class PosterGrabber
    SERVICE_HOST = "http://www.movieposterdb.com"
    SEARCH_PATH = "/search/?query=%{query}"
    MOVIE_PATH = "/movie/%{id}"

    def grab_poster(title, year)
      movie_url = parse_movie_url(fetch_search_results(title), year)
      parse_poster_url(fetch_movie_page(movie_url))
    end

    def grab_poster_by_imdb(imdb_id)
      movie_url = SERVICE_HOST + MOVIE_PATH % {id: imdb_id}
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
        year_node = cell.at_css('span b')
        year_node && year_node.content == year.to_s
      end

      raise MovieNotFoundError if cell.nil?

      SERVICE_HOST + cell.at_css('a')['href']
    end

    def parse_poster_url(page)
      doc = Nokogiri::HTML(page)
      doc.at_css('.poster a > img')['data-original']
    end
  end
end
