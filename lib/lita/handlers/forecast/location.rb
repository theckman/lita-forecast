# -*- coding: UTF-8 -*-
require 'geocoder'
require 'lita/handlers/forecast/mixins'

module LitaForecast
  # Something
  #
  class Location
    include LitaForecast::Mixins

    attr_accessor :lita_redis

    def initialize(redis)
      @lita_redis = redis
    end

    def find_location(search)
      loc = lita_redis.hgetall("alias:#{search}").symbolize_keys

      if loc.empty?
        g = Geocoder.search(search)[0].data
        gl = geo_location(g)
        loc = { lat: g['geometry']['viewport']['northeast']['lat'],
                lng: g['geometry']['viewport']['northeast']['lng'],
                desc: "#{gl[:city]}, #{gl[:state]}" }
      end

      loc
    end
  end
end
