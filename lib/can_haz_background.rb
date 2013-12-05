require "can_haz_poster/version"

module CanHazBackground
  MovieNotFoundError = Class.new(StandardError)

  autoload :GrabberBackground, 'can_haz_background/grabber_background'

  def self.grab_bg(title, year)
    GrabberBackground.new.grab_bg(title,year)
  end
end

CanHazBackground.grab_bg('The Matrix', 1999)

