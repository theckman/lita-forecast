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
  g.homepage    = 'https://github.com/theckman/lita_forecast'
  g.license     = 'MIT'
  g.required_ruby_version = '>= 2.0.0'
  g.metadata = { 'lita_plugin_type' => 'handler' }

  g.test_files  = `git ls-files spec/*`.split
  g.files       = `git ls-files`.split

  g.add_development_dependency 'bundler', '~> 1.5'
  g.add_development_dependency 'rake', '~> 10.2'
  g.add_development_dependency 'rubocop', '~> 0.35.0'
  g.add_development_dependency 'rspec', '~> 3.0'
  g.add_development_dependency 'fuubar', '>= 2.0.0.rc1'
  g.add_development_dependency 'coveralls', '~> 0.7.0'
  g.add_development_dependency 'simplecov', '~> 0.8.2'

  g.add_runtime_dependency 'hashie', '~> 3.0'
  g.add_runtime_dependency 'lita', '>= 3.0.0'
  g.add_runtime_dependency 'forecast_io', '~> 2.0.0'
  g.add_runtime_dependency 'geocoder', '~> 1.1', '>= 1.1.9'
  g.add_runtime_dependency 'compass_rose', '~> 0.1.0'
end
