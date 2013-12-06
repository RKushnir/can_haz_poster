require 'open-uri'
require 'net/http'
require 'nokogiri'

SERVICE_HOST = 'https://www.themoviedb.org'

def parse_bg_url(page = "https://www.themoviedb.org/movie/603-the-matrix
")
  doc = Nokogiri::HTML(open(page))                                                                # requested movie
  show_all_bg = SERVICE_HOST + doc.css('#mainCol h3:nth-child(17) > a:nth-child(3)').attr('href') # link to "Show All"
  movie_bg_list = Nokogiri::HTML(open(show_all_bg))                                               # "Show All" - page with all backgrounds for movie
  url_bg = movie_bg_list.css('script:nth-child(7)').text.scan(/url: '(.*)'/).last.first           # get link of bg collection inside script
  url_bg = SERVICE_HOST + url_bg

  doc = Nokogiri::HTML(open(url_bg))
  #bg_arr = []
  doc.css('#backdrops .delete').each do |link|
    puts link.css('a.lightbox').attr('href')
  end
  #bg_arr
end

parse_bg_url