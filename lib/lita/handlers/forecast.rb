# -*- coding: UTF-8 -*-
require 'lita/handlers/forecast/mixins'
require 'lita/handlers/forecast/weather'

module Lita
  module Handlers
    # Lita Forecast.io plugin!
    # this provides handlers for US and Canadian units
    #
    class Forecast < Handler
      include LitaForecast::Mixins
      include LitaForecast::Weather

      def self.default_config(config)
        config.api_key = nil
      end

      route(
        /^wx\s(.*)$/,
        :weather_us,
        command: true,
        help: {
          'wx san francisco' => 'Get the weather for San Francisco'
        }
      )

      route(
        /^wc\s(.*)$/,
        :weather_ca,
        command: true,
        help: {
          'wc toronto' => 'You want the weather for Toronto, eh?'
        }
      )

      def weather_us(response)
        response.reply(build_weather('us', response))
      end

      def weather_ca(response)
        response.reply(build_weather('ca', response))
      end

      def build_weather(units, response)
        weather(response, api_key, units)
      end

      private

      def api_key
        Lita.config.handlers.forecast.api_key
      end

      Lita.register_handler(Forecast)
    end
  end
end
