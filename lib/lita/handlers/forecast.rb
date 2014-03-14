# -*- coding: UTF-8 -*-
require 'forecast_io'
require 'geocoder'

module Lita
  module Handlers
    # Lita Forecast.io plugin!
    #
    class Forecast < Handler
      VERSION = '0.0.1'

      attr_reader :forecast

      route(
        /^wx\s(.*)$/,
        :weather,
        command: true,
        help: {
          'wx san francisco' => 'Get the weather for San Francisco!'
        }
      )

      def self.default_config(config)
        config.api_key = nil
      end

      def weather(response)
        search = args.join(' ')
        x = Geocoder.search(search)[0].data
        response.reply("#{x['viewport']['northeast']['lat']}, #{x['viewport']['northeast']['lng']}")
      end

      private

      def set_forecast_config
        ForecastIO.api_key = Lita.config.handlers.forecast.api_key
      end
    end
  end
end
