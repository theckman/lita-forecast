# -*- coding: UTF-8 -*-
# This is a dummy Handler so the forecast.io API key has a reasonable
# namespace
#
module Lita
  module Handlers
    # Lita Forecast.io plugin!
    # This Handler is basically a no-op and is used only for the
    # 'forecast' handler namespace.
    #
    class Forecast < Handler
      def self.default_config(config)
        config.api_key = nil
      end
      Lita.register_handler(Forecast)
    end
  end
end
