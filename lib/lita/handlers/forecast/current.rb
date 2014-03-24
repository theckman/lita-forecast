# -*- coding: UTF-8 -*-
require 'lita/handlers/forecast/mixins'

module LitaForecast
  # LitaForecast::Current
  #
  class Current
    include LitaForecast::Mixins

    def initialize(forecast)
      @f = forecast
    end

    def conditions
      c = currently
      "#{temp} (feels like #{feels}) #{c['summary']}; Winds #{wind}; " \
      "Humidity #{humidity}; Dew Pt #{dew_pt}; Pressure #{pressure}; Cloud " \
      "cover #{clouds}.\n" \
      "Next hour: #{next_hour} Next 24h: #{today}"
    end

    private

    def currently
      @f['currently']
    end

    def temp
      "#{currently['temperature'].round(1)}#{units(@f)[:t]}"
    end

    def feels
      "#{currently['apparentTemperature'].round(1)}#{units(@f)[:t]}"
    end

    def wind
      direction = Compass::Rose.direction(currently['windBearing'], 16)[:abbr]
      "#{direction} #{currently['windSpeed'].round(1)}#{units(@f)[:w]}"
    end

    def humidity
      "#{(currently['humidity'] * 100).round(0)}%"
    end

    def dew_pt
      "#{currently['dewPoint'].round(1)}#{units(@f)[:t]}"
    end

    def pressure
      "#{currently['pressure'].round(1)}mb"
    end

    def clouds
      "#{(currently['cloudCover'] * 100).round(0)}%"
    end

    def next_hour
      @f['minutely']['summary']
    end

    def today
      @f['hourly']['summary']
    end
  end
end
