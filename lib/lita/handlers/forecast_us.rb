# -*- coding: UTF-8 -*-
require 'forecast_io'
require 'compass_rose'
require 'lita/handlers/forecast/mixins'
require 'lita/handlers/forecast/response'
require 'lita/handlers/forecast/persistence'

module Lita
  module Handlers
    # Lita Forecast.io plugin!
    #
    class ForecastUS < Handler
      include LitaForecast::Mixins

      route(
        /^wx\s(.*)$/,
        :weather_us,
        command: true,
        help: {
          'wx san francisco' => 'Get the weather for San Francisco'
        }
      )

      def self.default_config(config)
        config.api_key = nil
      end

      def weather_us(response)
        redis.set('pass', 'fail')
        location = LitaForecast::Location.new(LitaForecast.redis)
          .find_location(response.args.join(' '))
        f = weather(api_key, location.merge(params: { units: 'us' }))
        response.reply(LitaForecast::Response.new(f, location[:desc]).generate)
      end

      private

      def api_key
        Lita.config.handlers.forecast.api_key
      end

      Lita.register_handler(ForecastUS)
    end
  end
end
