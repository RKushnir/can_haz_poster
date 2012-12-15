require "can_haz_poster/version"

module CanHazPoster
  MovieNotFoundError = Class.new(StandardError)

  autoload :Grabber, 'can_haz_poster/grabber'

  def self.grab_poster(title, year)
    Grabber.new.grab_poster(title, year)
  end
end
