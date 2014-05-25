# -*- coding: UTF-8 -*-
require 'spec_helper'
require 'hashie'

# Class for stubbing Geolocation data
#
class MockGeocoderClass
  DATA = {
    'address_components' => [
      { 'long_name' => 'San Francisco', 'types' => %w(locality) },
      { 'short_name' => 'CA', 'types' => %w(administrative_area_level_1) }
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

  describe '.name' do
    context 'when given more than two arga' do
      it 'should raise ArgumentError' do
        expect do
          @lfloc.send(:name, nil, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than two args' do
      it 'should raise ArgumentError' do
        expect do
          @lfloc.send(:name, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when looking for a city' do
      context 'when given a location with a city and state' do
        let(:location) { { city: 'San Francisco', state: 'CA' } }
        subject { @lfloc.send(:name, :city, location) }

        it { should be_an_instance_of String }

        it { should eql 'San Francisco' }
      end

      context 'when given a location with a city' do
        let(:location) { { city: 'San Francisco' } }
        subject { @lfloc.send(:name, :city, location) }

        it { should be_an_instance_of String }

        it { should eql 'San Francisco' }
      end

      context 'when given a location without a city' do
        let(:location) { { state: 'CA' } }
        subject { @lfloc.send(:name, :city, location) }

        it { should be_an_instance_of String }

        it { should eql '' }
      end
    end

    context 'when looking for a state' do
      context 'when given location with a city and a state' do
        let(:location) { { city: 'San Francisco', state: 'CA' } }
        subject { @lfloc.send(:name, :state, location) }

        it { should be_an_instance_of String }

        it { should eql 'CA' }
      end

      context 'when given location with a state' do
        let(:location) { { state: 'CA' } }
        subject { @lfloc.send(:name, :state, location) }

        it { should be_an_instance_of String }

        it { should eql 'CA' }
      end

      context 'when given location with only a city' do
        let(:location) { { city: 'San Francisco' } }
        subject { @lfloc.send(:name, :state, location) }

        it { should be_an_instance_of String }

        it { should eql '' }
      end
    end
  end

  describe '.desc' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          @lfloc.send(:desc, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise Argument Error' do
        expect do
          @lfloc.send(:desc)
        end.to raise_error ArgumentError
      end
    end

    context 'when provided a location with a city and state' do
      let(:loc_hash) { { city: 'San Francisco', state: 'CA' } }
      subject { @lfloc.send(:desc, loc_hash) }

      it { should be_an_instance_of String }

      it { should eql 'San Francisco, CA'}
    end

    context 'when provided a location with only a state' do
      let(:loc_hash) { { state: 'CA' } }
      subject { @lfloc.send(:desc, loc_hash) }

      it { should be_an_instance_of String }

      it { should eql 'CA' }
    end

    context 'when provided a location with only a city' do
      let(:loc_hash) { { city: 'San Francisco' } }
      subject { @lfloc.send(:desc, loc_hash) }

      it { should be_an_instance_of String }

      it { should eql 'San Francisco' }
    end
  end

  describe '.find_location' do
    before do
      allow(Geocoder).to receive(:search)
        .and_return([MockGeocoderClass])
    end

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
