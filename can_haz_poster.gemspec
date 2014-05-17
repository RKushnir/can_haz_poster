# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'can_haz_poster/version'

Gem::Specification.new do |gem|
  gem.name          = "can_haz_poster"
  gem.version       = CanHazPoster::VERSION
  gem.authors       = ["Roman"]
  gem.email         = ["broilerster@gmail.com"]
  gem.description   = %q{Grabs movie posters from the Web}
  gem.summary       = %q{Given a title and a year of the movie looks for the poster}
  gem.homepage      = "https://github.com/RKushnir/can_haz_poster"

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'nokogiri', '~> 1.5', '>= 1.5.5'
  gem.add_development_dependency 'rspec', '~> 2.12', '>= 2.12.0'
  gem.add_development_dependency 'rake', '~> 10.0', '>= 10.0.3'
  gem.add_development_dependency 'webmock', '~> 1.9', '>= 1.9.0'
end
