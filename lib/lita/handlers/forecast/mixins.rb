# -*- coding: UTF-8 -*-
require 'forecast_io'

# The thing
#
module LitaForecast
  # MOdule
  #
  module Mixins
    def weather(api_key, l = {})
      ForecastIO.api_key = api_key
      l = { params: { exclude: 'alerts' } }.merge(l)
      ForecastIO.forecast(l[:lat].to_f, l[:lng].to_f, params: l['params'])
    end

    def round(precision, val)
      base = 10**precision
      format('%g', (val * base).to_i / base.to_f)
    end

    def geo_location(result)
      h = {}
      result['address_components'].each do |a|
        a['types'].each do |t|
          h[:city] = a['long_name'] if t == 'locality'
          h[:state] = a['short_name'] if t == 'administrative_area_level_1'
        end
      end
      h
    end

    def units(forecast)
      if forecast['flags']['units'] == 'us'
        { t: 'F', w: 'mph', v: 'mi' }
      else
        { t: 'C', w: 'kmph', v: 'km' }
      end
    end
  end
end
