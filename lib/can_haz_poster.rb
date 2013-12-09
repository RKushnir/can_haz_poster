require "can_haz_poster/version"

module CanHazPoster
  MovieNotFoundError = Class.new(StandardError)

  autoload :Grabber, 'can_haz_poster/grabber'
  autoload :GrabberBackground, 'can_haz_poster/grabber_background'

  def self.grab_poster(title, year)
    Grabber.new.grab_poster(title, year)
  end

  def self.grab_bg(title, year)
    GrabberBackground.new.grab_bg(title, year)
  end
end