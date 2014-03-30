# -*- coding: UTF-8 -*-
require 'lita/handlers/forecast/persistence'

module Lita
  module Handlers
    # Lita::Handlers::ForecastLocations
    #
    class ForecastLocations < Handler
      route(
        /^wadd\s(.+?)\s([0-9.,\-]+?)\s([0-9.,\-]+)\s*(.*)$/,
        :location_add,
        command: true,
        help: {
          'wadd sf 37.78439928029 -122.39204721970 PagerDuty San Francisco' =>
            'Add the lat and long of the office with the alias "sf"'
        }
      )

      route(
        /^wrm\s(.+?)$/,
        :location_rm,
        command: true,
        help: {
          'wrm sf' =>
            'Remove the specified alias, in this case "sf"'
        }
      )

      route(
        /^wl$/,
        :locations,
        command: true,
        help: {
          'wl' => 'List known weather aliases'
        }
      )

      def self.default_config(config)
        config.api_key = nil
      end

      def location_add(response)
        r = response.matches[0]
        return response.reply('Already there!') if alias_exists?(r[0])

        d = saved_location_hash(r)
        add_to_cache(d)

        response.reply("#{r[0]} added to the cache at [#{r[1]}, #{r[2]}]")
      end

      def location_rm(response)
        key = "alias:#{response.matches[0][0]}"
        return response.reply('Alias not found') unless alias_exists?(key)
        rm_from_cache(key)
        if LitaForecast.redis.keys(key).empty?
          return response.reply('Alias removed!')
        else
          return response.reply('Somehow that failed... I need an adult!')
        end
      end

      def locations(response)
        k = LitaForecast.redis.keys('alias:*').map { |v| v.gsub('alias:', '') }
        return response.reply('There are no weather aliases') if k.empty?
        response.reply("Known weather aliases: #{k.join(', ')}")
      end

      private

      def alias_exists?(key)
        return true unless LitaForecast.redis.hgetall(key).empty?
        false
      end

      def add_to_cache(location)
        key = "alias:#{location[:name]}"
        LitaForecast.redis.pipelined do
          [:lat, :lng].each do |k|
            LitaForecast.redis.hset(key, k.to_s, location[k])
          end
        end
      end

      def rm_from_cache(key)
        LitaForecast.redis.del(key)
      end

      def saved_location_hash(r)
        d = (r[3].nil? || r[3].empty?) ? r[0] : r[3].slice(0..29)
        { name: r[0], lat: r[1], lng: r[2], desc: d }
      end

      Lita.register_handler(ForecastLocations)
    end
  end
end
