# CanHazPoster

Grabs movie posters

## Installation

Add this line to your application's Gemfile:

    gem 'can_haz_poster', github: 'RKushnir/can_haz_poster'

And then execute:

    $ bundle

## Usage

```ruby
CanHazPoster.grab_poster('Casino Royale', 2006)
CanHazPoster.grab_poster_by_imdb('0381061')

CanHazPoster.grab_backdrops('The Matrix', 1999)
```

## Contributors
Thanks to Artur([@yozzz](https://github.com/yozzz)) for adding the backdrops grabber.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
