# -*- coding: UTF-8 -*-

# The thing
#
module LitaForecast
  # MOdule
  #
  module Mixins
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
