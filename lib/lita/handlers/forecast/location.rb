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
                desc: desc(gl) }
      end

      loc
    end

    private

    def desc(loc)
      l = ''
      h = { c: city(loc), s: state(loc) }
      l << h[:c]
      l << ', ' unless h[:c].empty? || h[:s].empty?
      l << h[:s]
      l
    end

    def city(loc)
      c = ''
      c << loc[:city] if loc[:city].is_a?(String) && !loc[:city].empty?
      c
    end

    def state(loc)
      s = ''
      s << loc[:state] if loc[:state].is_a?(String) && !loc[:state].empty?
      s
    end
  end
end
