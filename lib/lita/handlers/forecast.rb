# -*- coding: UTF-8 -*-
require 'forecast_io'
require 'geocoder'
require 'compass_rose'
require 'lita/handlers/forecast/location'

module Lita
  module Handlers
    # Lita Forecast.io plugin!
    #
    class Forecast < Handler
      def self.default_config(config)
        config.api_key = nil
      end

      Lita.register_handler(Forecast)
    end
  end
end
