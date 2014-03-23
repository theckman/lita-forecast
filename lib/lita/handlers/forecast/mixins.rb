# -*- coding: UTF-8 -*-

module LitaForecast
  # The random mixins I'll need, eventually
  #
  module Mixins
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
