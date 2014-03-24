# -*- coding: UTF-8 -*-
require 'spec_helper'

# Class for stubbing Redis class
#
class MockRedisClass
  def self.hgetall(search)
    Hashie::Mash.new({})
  end
end

# Class for mocking LitaResponse object
#
class MockResponseClass
  def self.args
    []
  end
end

describe LitaForecast::Weather do
  include LitaForecast::Weather
  let(:forecast_h) do
    {
      'currently' => {
        'temperature' => 100.11,
        'apparentTemperature' => 102.11,
        'summary' => 'weather',
        'windBearing' => 0,
        'windSpeed' => 5.11,
        'humidity' => 0.10,
        'dewPoint' => 20.11,
        'pressure' => 1020.11,
        'cloudCover' => 0.01
      },
      'daily' => {
        'summary' => 'daily weather',
        'data' => [
          {
            'summary' => 'weather today!',
            'temperatureMax' => 68.0,
            'temperatureMin' => 60.2,
            'precipProbability' => 0,
            'windSpeed' => 0,
            'windBearing' => 0
          },
          {
            'summary' => 'weather tomorrow!',
            'temperatureMax' => 70.0,
            'temperatureMin' => 62.1,
            'precipProbability' => 1,
            'precipType' => 'rain',
            'windSpeed' => 10,
            'windBearing' => 270
          }
        ]
      },
      'minutely' => { 'summary' => 'minutely weather' },
      'hourly' => { 'summary' => 'hourly weather' },
      'flags' => { 'units' => 'us' }
    }
  end
  let(:good_string) do
    "San Francisco, CA:\n\nNow: 100.1F (feels like 102.1F) weather; Winds " \
    "N 5.1mph; Humidity 10%; Dew Pt 20.1F; Pressure 1020.1mb; Cloud cover " \
    "1%.\nNext hour: minutely weather Next 24h: hourly weather\n\nSummary: " \
    "daily weather\nToday: weather today! High 68F, Low 60F. 0% chance of " \
    "precipitation. Winds N 0mph.\nTomorrow: weather tomorrow! High 70F, " \
    "Low 62F. 100% chance of rain. Winds W 10mph.\n"
  end

  describe '#weather_forecast' do
    context 'when given more than three args' do
      it 'should raise ArgumentError' do
        expect do
          weather_forecast(nil, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          weather_forecast
        end.to raise_error ArgumentError
      end
    end

    context 'when passed an API key and location hash' do
      before do
        allow(ForecastIO).to receive(:api_key=)
          .with(any_args).and_return(nil)
        allow(ForecastIO).to receive(:forecast)
          .with(any_args).and_return(forecast_h)
      end

      let(:l_h) do
        {
          params: {},
          lat: 37.7749295,
          lng: -122.4194155
        }
      end
      subject { weather_forecast('', l_h) }

      it { should be_an_instance_of Hash }

      it { should eql forecast_h }
    end
  end

  describe '#weather' do
    context 'when given more than three args' do
      it 'should raise ArgumentError' do
        expect do
          weather(nil, nil, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than two args' do
      it 'should raise ArgumentError' do
        expect do
          weather(nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given response and api_key' do
      before do
        allow(LitaForecast).to receive(:redis).and_return(MockRedisClass)
        allow(self).to receive(:weather_forecast)
          .and_return(forecast_h)
        allow_any_instance_of(LitaForecast::Location)
          .to receive(:find_location).with(any_args)
          .and_return(
            lat: 37.7749295, lng: -122.4194155, desc: 'San Francisco, CA'
          )
      end

      subject { weather(MockResponseClass, '') }

      it { should be_an_instance_of String }

      it { should eql good_string }
    end
  end
end
