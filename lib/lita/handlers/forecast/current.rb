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
      "Humidity #{humidity}%; Dew Pt #{dew_pt}; Pressure #{pressure}; Cloud " \
      "cover #{clouds}.\n" \
      "Next hour: #{next_hour} Next 24h: #{today}"
    end

    def currently
      @f['currently']
    end

    def temp
      "#{round(1, currently['temperature'])}#{units(@f)[:t]}"
    end

    def feels
      "#{round(1, currently['apparentTemperature'])}#{units(@f)[:t]}"
    end

    def wind
      direction = Compass::Rose.direction(currently['windBearing'], 16)[:abbr]
      "#{direction} #{round(1, currently['windSpeed'])}#{units(@f)[:w]}"
    end

    def humidity
      round(0, currently['humidity'] * 100)
    end

    def dew_pt
      "#{round(1, currently['dewPoint'])}#{units(@f)[:t]}"
    end

    def pressure
      "#{round(1, currently['pressure'])}mb"
    end

    def clouds
      "#{round(1, currently['cloudCover'] * 100)}%"
    end

    def next_hour
      @f['minutely']['summary']
    end

    def today
      @f['hourly']['summary']
    end
  end
end
