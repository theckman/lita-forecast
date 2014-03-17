# -*- coding: UTF-8 -*-
require 'English'
require 'compass_rose'
require 'lita/handlers/forecast/mixins'

module LitaForecast
  # LitaForecast::Future
  #
  class Future
    include LitaForecast::Mixins

    def method_missing(method, *args, &block)
      super unless /^generate_(.*)$/.match(method)
      m = $LAST_MATCH_INFO
      super unless %w(today tomorrow).include?(m[1])
      i = { today: 0, tomorrow: 1 }[m[1].to_sym]
      generate_day(i, m[1])
    end

    def initialize(forecast)
      @f = forecast
    end

    def conditions
      future = ''
      future << generate_summary
      future << generate_today
      future << generate_tomorrow
    end

    private

    def daily
      @f['daily']['data']
    end

    def generate_summary
      "Summary: #{@f['daily']['summary']}\n"
    end

    def generate_day(index, day)
      @i = daily[index]
      @d = day
      "#{summary} #{high_low} #{precip}\n"
    end

    def summary
      "#{@d.capitalize}: #{@i['summary']}"
    end

    def high_low
      "High #{round(0, @i['temperatureMax'])}#{units(@f)[:t]}, " \
      "Low #{round(0, @i['temperatureMin'])}#{units(@f)[:t]}."
    end

    def precip
      type = @i['precipType'] || 'precipitation'
      "#{round(0, @i['precipProbability'] * 100)}% chance of #{type}."
    end

    def wind
      direction = Compass::Rose.direction(@i['windBearing'], 16)
      "Winds #{direction} #{round(1, @i['windSpeed'])}#{units(@f)[:w]}"
    end
  end
end
