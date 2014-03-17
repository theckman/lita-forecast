# -*- coding: UTF-8 -*-
require 'lita/handlers/forecast/mixins'
require 'lita/handlers/forecast/weather'

module Lita
  module Handlers
    # Lita::Handlers::ForecastCA
    # Weather for our brothers from the north
    #
    # TODO: Should probably just make this an arg you can pass in...
    #
    class ForecastCA < Handler
      include LitaForecast::Mixins
      include LitaForecast::Weather

      route(
        /^wc\s(.*)$/,
        :weather_ca,
        command: true,
        help: {
          'wc toronto' => 'You want the weather for Toronto, eh?'
        }
      )

      def self.default_config(config)
        config.api_key = nil
      end

      def weather_ca(response)
        response.reply(weather(response, api_key, 'ca'))
      end

      private

      def api_key
        Lita.config.handlers.forecast.api_key
      end

      Lita.register_handler(ForecastCA)
    end
  end
end
