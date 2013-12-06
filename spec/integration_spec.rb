require 'spec_helper'
require 'can_haz_poster'
require 'can_haz_background'

describe CanHazPoster::Grabber do
  before do
    stub_http_request(:get, "http://www.movieposterdb.com/search/").
      with(query: {query: "Casino Royale"}).
      to_return(body: File.new('spec/fixtures/search_results.html'), status: 200)

    stub_http_request(:get, "http://www.movieposterdb.com/movie/0381061/Casino-Royale.html").
      to_return(body: File.new('spec/fixtures/movie_page.html'), status: 200)
  end

  it "finds movie poster by title and year" do
    posters = subject.grab_poster("Casino Royale", 2006)
    posters.should == "http://www.movieposterdb.com/posters/11_01/2006/381061/l_381061_3b296a44.jpg"
  end
end


describe CanHazBackground::GrabberBackground do
  before do
    stub_http_request(:get, "https://www.themoviedb.org/search?query=The%20Matrix").

      to_return(body: File.new('spec/fixtures/bg_search_result.html'), status: 200)

    stub_http_request(:get, "https://www.themoviedb.org/movie/603-the-matrix").
      to_return(body: File.new('spec/fixtures/bg_movie_page.html'), status: 200)

    stub_http_request(:get, "https://www.themoviedb.org/movie/603-the-matrix/backdrops").
      to_return(body: File.new('spec/fixtures/bg_show_all.html'), status: 200)

    stub_http_request(:get, "https://www.themoviedb.org/movie/603-the-matrix/images?kind=backdrop&language=&translate=false").
      to_return(body: File.new('spec/fixtures/bg_collection.html'), status: 200)
  end

  it "finds movie background by title and year" do
    background = subject.grab_bg("The Matrix", 1999)
    background.should include("https://d3gtl9l2a4fn1j.cloudfront.net/t/p/original/7u3pxc0K1wx32IleAkLv78MKgrw.jpg")
  end

end
