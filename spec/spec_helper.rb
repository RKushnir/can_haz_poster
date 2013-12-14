require 'webmock/rspec'

def fixture(path)
  File.new('spec/fixtures/' + path)
end
