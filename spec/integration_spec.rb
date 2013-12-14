require 'spec_helper'
require 'can_haz_poster'

describe CanHazPoster do
  subject(:grabber) { described_class }

  describe "poster grabbing" do
    let(:poster_url) { "http://www.movieposterdb.com/posters/11_01/2006/381061/l_381061_3b296a44.jpg" }

    before do
      stub_http_request(:get, "http://www.movieposterdb.com/search/").
        with(query: {query: "Casino Royale"}).
        to_return(body: fixture('search_results.html'))

      stub_http_request(:get, "http://www.movieposterdb.com/movie/0381061/Casino-Royale.html").
        to_return(body: fixture('movie_page.html'))
    end

    it "finds movie poster by title and year" do
      expect(grabber.grab_poster("Casino Royale", 2006)).to eq(poster_url)
    end
  end

  describe "backdrops grabbing" do
    let(:backdrop_url) { "https://d3gtl9l2a4fn1j.cloudfront.net/t/p/original/7u3pxc0K1wx32IleAkLv78MKgrw.jpg" }

    before do
      stub_http_request(:get, "https://www.themoviedb.org/search?query=The%20Matrix").
        to_return(body: fixture('bd_search_result.html'))

      stub_http_request(:get, "https://www.themoviedb.org/movie/603-the-matrix/images?kind=backdrop").
        to_return(body: fixture('bd_collection.html'))
    end

    it "finds movie backdrops by title and year" do
      expect(grabber.grab_backdrops("The Matrix", 1999)).to include(backdrop_url)
    end
  end
end
