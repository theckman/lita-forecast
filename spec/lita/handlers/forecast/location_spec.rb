# -*- coding: UTF-8 -*-
require 'spec_helper'
require 'hashie'

# Class for stubbing Geolocation data
#
class MockGeocoderClass
  DATA = {
    'address_components' => [
      {
        'long_name' => 'San Francisco',
        'types' => %w(locality)
      },
      {
        'short_name' => 'CA',
        'types' => %w(administrative_area_level_1)
      }
    ],
    'geometry' => {
      'location' => { 'lat' => 37.7749295, 'lng' => -122.4194155 }
    }
  }

  def self.data
    DATA
  end
end

# Class for stubbing Redis class
#
class MockRedisClass
  def self.hgetall(search)
    Hashie::Mash.new({})
  end
end

describe LitaForecast::Location do
  before do
    @lfloc = LitaForecast::Location.new(MockRedisClass)
  end

  describe '#new' do
    context 'when passed more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          LitaForecast::Location.new(nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when passed less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          LitaForecast::Location.new
        end.to raise_error ArgumentError
      end
    end

    context 'when passed an object' do
      subject { LitaForecast::Location.new(MockRedisClass) }

      it { should be_an_instance_of LitaForecast::Location }
    end
  end

  describe '.lita_redis' do
    context 'when given an arg' do
      subject { LitaForecast::Location.new(MockRedisClass).lita_redis }

      it { should eql MockRedisClass }
    end
  end

  describe '.find_location' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          @lfloc.find_location(nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less tha one arg' do
      it 'should raise ArgumentError' do
        expect do
          @lfloc.find_location
        end.to raise_error ArgumentError
      end
    end

    context 'when passed "san francisco" and not cached' do
      before do
        allow_any_instance_of(Geocoder).to receive(:search)
          .and_return([MockGeocoderClass])
      end
      let(:good_hash) do
        { lat: 37.7749295, lng: -122.4194155, desc: 'San Francisco, CA' }
      end

      subject { @lfloc.find_location('san francisco') }

      it { should be_an_instance_of Hash }

      it { should eql good_hash }
    end

    context 'when passed "san francisco" and cached' do
      before do
        @cr = { lat: 37.7749295, lng: -122.4194155, desc: 'San Francisco, CA' }
        allow_any_instance_of(MockRedisClass).to receive(:hgetall)
          .and_return(@cr)
      end

      subject { @lfloc.find_location('san francisco') }

      it { should be_an_instance_of Hash }

      it { should eql @cr }
    end
  end
end
