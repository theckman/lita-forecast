# -*- coding: UTF-8 -*-
require 'compass_rose'
require 'lita/handlers/forecast/current'
require 'lita/handlers/forecast/future'

module LitaForecast
  # LutaForecast::Response
  #
  class Response
    def initialize(forecast, location)
      @forecast = forecast
      @location = location
      @current = LitaForecast::Current.new(@forecast)
      @future = LitaForecast::Future.new(@forecast)
    end

    def generate
      response = "#{@location}:\n\n"
      response << "Now: #{@current.conditions}\n\n"
      response << @future.conditions
      response
    end
  end
end
