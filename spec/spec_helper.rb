# -*- coding: UTF-8 -*-
require 'rspec'
require 'lita/rspec'
require 'simplecov'
require 'coveralls'
require 'lita-forecast'

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter '/spec/'
end
