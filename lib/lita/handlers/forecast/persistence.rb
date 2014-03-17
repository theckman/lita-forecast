# -*- coding: UTF-8 -*-
require 'lita'
require 'redis-namespace'

# LitaForecast module
#
module LitaForecast
  FORECAST_NAMESPACE = 'handlers:forecast'

  class << self
    def redis
      @forecastredis ||= begin
        Redis::Namespace.new(FORECAST_NAMESPACE, redis: Lita.redis)
      end
      @forecastredis
    end
  end
end
