require 'open-uri'
require 'net/http'
require 'nokogiri'

module CanHazPoster
  class Grabber

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

  class GrabberBackground

    SERVICE_HOST = 'https://www.themoviedb.org'
    SEARCH_PATH = '/search?query=%{query}'

    def grab_bg(title, year)
      movie_url = parse_movie_url(fetch_search_results(title), year)
      parse_bg_url(movie_url)
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

      SERVICE_HOST + cell.css('h3 > a').first['href']
    end

    def parse_bg_url(page)
      doc = Nokogiri::HTML(open(page))                                                                # requested movie
      show_all_bg = SERVICE_HOST + doc.css('#mainCol h3:nth-child(17) > a:nth-child(3)').attr('href') # link to "Show All"
      movie_bg_list = Nokogiri::HTML(open(show_all_bg))                                               # "Show All" - page with all backgrounds for movie
      url_bg = movie_bg_list.css('script:nth-child(7)').text.scan(/url: '(.*)'/).last.first           # get link of bg collection inside script

      url_bg = SERVICE_HOST + url_bg

      doc = Nokogiri::HTML(open(url_bg))
      bg_arr = []
      doc.css('#backdrops .delete').each do |link|
        bg_arr << link.css('a.lightbox').attr('href').text
      end
      bg_arr
    end
  end
end