# -*- coding: UTF-8 -*-
require 'English'

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'lita-forecast/version'

Gem::Specification.new do |g|
  g.name        = 'lita-forecast'
  g.version     = LitaForecast::VERSION
  g.date        = Time.now.strftime('%Y-%m-%d')
  g.description = 'Lita plugin for Forecast.io'
  g.summary     = 'Lita + Forecast.io'
  g.authors     = ['Tim Heckman']
  g.email       = 't@heckman.io'
  g.homepage    = 'https://github.com/theckman/lita-forecast'
  g.license     = 'MIT'

  g.test_files  = %x{git ls-files spec/*}.split
  g.files       = %x{git ls-files}.split

  g.add_development_dependency 'rake', '~>10.1', '>= 10.1.0'
  g.add_development_dependency 'rspec', '~>2.14', '>= 2.14.1'
  g.add_development_dependency 'rubocop', '~> 0.18', '>= 0.18.1'
  g.add_development_dependency 'fuubar', '~> 1.3', '>= 1.3.2'
  g.add_development_dependency 'simplecov', '~> 0.8', '>= 0.8.2'
  g.add_development_dependency 'coveralls', '~> 0.7', '>= 0.7.0'
  g.add_development_dependency 'awesome_print', '~> 1.2', '>= 1.2.0'
  g.add_development_dependency 'bundler', '>= 1.3'

  g.add_runtime_dependency 'lita', '~>3.0', '>= 3.0.0'
  g.add_runtime_dependency 'forecast_io', '~>2.0', '>= 2.0.0'
  g.add_runtime_dependency 'geocoder', '~>1.1', '>= 1.1.9'
end
