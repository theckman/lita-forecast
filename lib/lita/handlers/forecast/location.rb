# -*- coding: UTF-8 -*-
require 'hashie'
require 'geocoder'
require 'lita/handlers/forecast/mixins'

# mokey-patch to get .symbolize_keys!() from hashie
class Hash
  include Hashie::Extensions::SymbolizeKeys
end

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
      h = { c: name(:city, loc), s: name(:state, loc) }
      l << h[:c]
      l << ', ' unless h[:c].empty? || h[:s].empty?
      l << h[:s]
      l
    end

    def name(key, loc)
      n = ''
      n << loc[key] if loc[key].is_a?(String) && !loc[key].empty?
      n
    end
  end
end
