# -*- coding: UTF-8 -*-
require 'forecast_io'
require 'lita/handlers/forecast/location'
require 'lita/handlers/forecast/response'

# The thing
#
module LitaForecast
  # Module
  #
  module Weather
    def weather_forecast(api_key, l = {})
      ForecastIO.api_key = api_key
      l = { params: { exclude: 'alerts' } }.merge(l)
      ForecastIO.forecast(l[:lat].to_f, l[:lng].to_f, params: l[:params])
    end

    def weather(response, api_key, units = 'us')
      location = LitaForecast::Location.new(LitaForecast.redis).find_location(
        response.args.join(' '))
      f = weather_forecast(api_key, location.merge(params: { units: units }))
      LitaForecast::Response.new(f, location[:desc]).generate
    end
  end
end
