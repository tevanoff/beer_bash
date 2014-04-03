# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'beer_bash/version'

Gem::Specification.new do |s|
  s.name          = 'beer_bash'
  s.version       = BeerBash::VERSION
  s.authors       = ['Todd Evanoff']
  s.email         = ['evanoff@gmail.com']
  s.summary       = %q{See what tasty beverages are on tap at your favorite place, directly from your command line.}
  s.homepage      = 'http://github.com/tevanoff/beer_bash'
  s.license       = 'MIT'
  s.files         = `git ls-files -z`.split("\x0")
  s.require_paths = ['lib']
  s.bindir        = 'bin'
  s.executables   << 'ontap'

  s.add_development_dependency 'rake'

  s.add_dependency 'commander'
  s.add_dependency 'mechanize'
  s.add_dependency 'terminal-table'
end
