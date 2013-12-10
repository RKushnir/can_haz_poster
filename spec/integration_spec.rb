require 'spec_helper'
require 'can_haz_poster'

describe CanHazPoster::PosterGrabber do
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

describe CanHazPoster::BackdropGrabber do
  before do
    stub_http_request(:get, "https://www.themoviedb.org/search?query=The%20Matrix").
        to_return(body: File.new('spec/fixtures/bd_search_result.html'), status: 200)

    stub_http_request(:get, "https://www.themoviedb.org/movie/603-the-matrix/images?kind=backdrop").
        to_return(body: File.new('spec/fixtures/bd_collection.html'), status: 200)
  end

  it "finds movie backdrop by title and year" do
    background = subject.grab_backdrop("The Matrix", 1999)
    background.should include("https://d3gtl9l2a4fn1j.cloudfront.net/t/p/original/7u3pxc0K1wx32IleAkLv78MKgrw.jpg")
  end

end
