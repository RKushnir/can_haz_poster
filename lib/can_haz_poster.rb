require "can_haz_poster/version"

module CanHazPoster
  MovieNotFoundError = Class.new(StandardError)

  autoload :PosterGrabber, 'can_haz_poster/poster_grabber'
  autoload :BackdropGrabber, 'can_haz_poster/backdrop_grabber'

  def self.grab_poster(title, year)
    PosterGrabber.new.grab_poster(title, year)
  end
  
  def self.grab_backdrop(title, year)
    BackdropGrabber.new.grab_backdrop(title, year)
  end
end
