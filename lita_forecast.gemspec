# -*- coding: UTF-8 -*-
require 'English'

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'lita_forecast/version'

Gem::Specification.new do |g|
  g.name        = 'lita_forecast'
  g.version     = LitaForecast::VERSION
  g.date        = Time.now.strftime('%Y-%m-%d')
  g.description = 'Lita plugin for Forecast.io'
  g.summary     = 'Lita + Forecast.io'
  g.authors     = ['Tim Heckman']
  g.email       = 't@heckman.io'
  g.homepage    = 'https://github.com/theckman/lita_forecast'
  g.license     = 'MIT'

  g.test_files  = %x(git ls-files spec/*).split
  g.files       = %x(git ls-files).split

  g.add_development_dependency 'bundler', '~> 1.5'
  g.add_development_dependency 'rake', '~> 10.1.0'
  g.add_development_dependency 'rubocop', '~> 0.19.1'
  g.add_development_dependency 'rspec', '>= 3.0.0.beta2'
  g.add_development_dependency 'fuubar', '~> 1.3.2'
  g.add_development_dependency 'coveralls', '~> 0.7.0'
  g.add_development_dependency 'simplecov', '~> 0.8.2'

  g.add_runtime_dependency 'lita', '~>3.0.0'
  g.add_runtime_dependency 'forecast_io', '~>2.0.0'
  g.add_runtime_dependency 'geocoder', '~>1.1.9'
  g.add_runtime_dependency 'compass_rose', '~> 0.1.0'
end
