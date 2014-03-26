# -*- coding: UTF-8 -*-
require 'spec_helper'

# Mock Geocoder response class
#
class MockGeocoderData
  attr_reader :data

  def initialize(v1, v2)
    @data = "#{v1} #{v2}"
  end
end

describe Lita::Handlers::LocationSearch, lita_handler: true do
  before do
    allow(Geocoder).to receive(:search) do |s|
      [MockGeocoderData.new(s, 'heckman')]
    end

    allow_any_instance_of(Geocoder).to receive(:search) do |s|
      [MockGeocoderData.new(s, 'heckman')]
    end
  end
  let(:ls) { Lita::Handlers::LocationSearch.new('robot') }

  describe '.search_geocoder' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          ls.send(:search_geocoder, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          ls.send(:search_geocoder)
        end.to raise_error ArgumentError
      end
    end

    context 'when given search string' do
      it 'should call Geocoder.search with the query string' do
        expect(ls.send(:search_geocoder, "where's")).to eql "where's heckman"
      end
    end
  end

  describe '.generate_response' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          ls.send(:generate_response, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          ls.send(:generate_response)
        end.to raise_error ArgumentError
      end
    end

    context 'when passed a geocoder result' do
      it 'should parse the information correctly' do
        allow(ls).to receive(:geo_location).and_return(
          city: 'San Francisco', state: 'CA'
        )
        r = {
          'geometry' => {
            'location' => { 'lat' => 1, 'lng' => 2 }
          }
        }

        expect(ls.send(:generate_response, r))
          .to eql 'San Francisco, CA: 1, 2 :: !wadd <alias> 1 2 <description' \
                  '/city name>'
      end
    end
  end

  describe '.search' do
    it 'should return the search response from generate_response' do
      allow(subject)
        .to receive(:generate_response) do |s|
          "#{s} heckman"
        end
      allow(subject)
        .to receive(:search_geocoder) do |s|
          "#{s}"
        end
      send_command('ws urmom')
      expect(replies.last).to eql 'urmom heckman'
    end
  end
end
