# -*- coding: UTF-8 -*-
require 'spec_helper'

describe LitaForecast::Mixins do
  include LitaForecast::Mixins

  describe '#geo_location' do
    let(:geocoder) do
      {
        'address_components' => [
          { 'long_name' => 'San Francisco', 'types' => %w(locality) },
          { 'short_name' => 'CA', 'types' => %w(administrative_area_level_1) }
        ]
      }
    end

    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect { geo_location(nil, nil) }.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect { geo_location }.to raise_error ArgumentError
      end
    end

    context 'when result is a Geocoder hash' do
      subject { geo_location(geocoder) }

      it { should be_an_instance_of Hash }

      it 'should set the city to "San Francisco"' do
        expect(subject[:city]).to eql 'San Francisco'
      end

      it 'should set the state to CA' do
        expect(subject[:state]).to eql 'CA'
      end
    end
  end

  describe '#units' do
    let(:forecast_us) { { 'flags' => { 'units' => 'us' } } }
    let(:forecast_ca) { { 'flags' => { 'units' => 'ca' } } }

    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect { units(nil, nil) }.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect { units }.to raise_error ArgumentError
      end
    end

    context 'when passed a US ForecastIO response' do
      before do
        @unit = units(forecast_us)
      end
      subject { @unit }

      it { should be_an_instance_of Hash }

      context 'when the temp (:t) key' do
        subject { @unit[:t] }

        it { should be_an_instance_of String }

        it { should eql 'F' }
      end

      context 'when the wind (:w) key' do
        subject { @unit[:w] }

        it { should be_an_instance_of String }

        it { should eql 'mph' }
      end

      context 'when the visibility (:v) key' do
        subject { @unit[:v] }

        it { should be_an_instance_of String }

        it { should eql 'mi' }
      end
    end

    context 'when passed a CA ForecastIO response' do
      before do
        @unit = units(forecast_ca)
      end
      subject { @unit }

      it { should be_an_instance_of Hash }

      context 'when the temp (:t) key' do
        subject { @unit[:t] }

        it { should be_an_instance_of String }

        it { should eql 'C' }
      end

      context 'when the wind (:w) key' do
        subject { @unit[:w] }

        it { should be_an_instance_of String }

        it { should eql 'kmph' }
      end

      context 'when the visibility (:v) key' do
        subject { @unit[:v] }

        it { should be_an_instance_of String }

        it { should eql 'km' }
      end
    end
  end
end
