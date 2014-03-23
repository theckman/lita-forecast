# -*- coding: UTF-8 -*-
require 'geocoder'
require 'lita/handlers/forecast/mixins'

module LitaForecast
  # LitaForecast class for determining someone's location
  #
  class Location
    include LitaForecast::Mixins

    attr_accessor :lita_redis

    def initialize(redis)
      @lita_redis = redis
    end

    def find_location(search)
      loc = lita_redis.hgetall("alias:#{search}").symbolize_keys!

      if loc.empty?
        g = Geocoder.search(search)[0].data
        gl = geo_location(g)
        loc = { lat: g['geometry']['location']['lat'],
                lng: g['geometry']['location']['lng'],
                desc: "#{gl[:city]}, #{gl[:state]}" }
      end

      loc
    end
  end
end
