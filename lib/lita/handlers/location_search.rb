# -*- coding: UTF-8 -*-
require 'geocoder'
require 'lita/handlers/forecast/mixins'

module Lita
  module Handlers
    # Lita::Handlers::LocationSearch
    #
    class LocationSearch < Handler
      include LitaForecast::Mixins

      route(
        /^ws\s(.*)$/,
        :search,
        command: true,
        help: { 'ws san francisco' =>
          'find the lat and long for the location' }
      )

      def search(response)
        s = response.args.join(' ')
        r = search_geocoder(s)
        return response.reply('You made that up...') if r.empty?
        response.reply(generate_response(r))
      end

      private

      def search_geocoder(search)
        Geocoder.search(search)[0].data
      end

      def generate_response(result)
        l = geo_location(result)
        lat = result['geometry']['location']['lat']
        lng = result['geometry']['location']['lng']
        "#{l[:city]}, #{l[:state]}: #{lat}, #{lng} :: "\
        "!wadd <alias> #{lat} #{lng} <description/city name>"
      end

      Lita.register_handler(LocationSearch)
    end
  end
end
