# -*- coding: UTF-8 -*-
require 'spec_helper'

describe LitaForecast::Response do
  let(:forecast) do
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
  let(:location) { 'San Francisco, CA' }

  before do
    @response = LitaForecast::Response.new(forecast, location)
  end

  describe '.new' do
    context 'when given more than two args' do
      it 'should raise ArgumentError' do
        expect do
          LitaForecast::Response.new(nil, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than two args' do
      it 'should raise ArgumentError' do
        expect do
          LitaForecast::Response.new(nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given forecast and location' do
      subject { LitaForecast::Response.new(forecast, location) }

      it { should be_an_instance_of LitaForecast::Response }

      it 'should set the @forecast instance variable' do
        i = subject.instance_variable_get(:@forecast)
        expect(i).to eql forecast
      end

      it 'should set the @location instance variable' do
        i = subject.instance_variable_get(:@location)
        expect(i).to eql location
      end
    end
  end

  describe '.generate' do
    let(:fc_s) do
      'Now: 100.1F (feels like 102.1F) weather; Winds N 5.1mph; Humidity 10%' \
      "; Dew Pt 20.1F; Pressure 1020.1mb; Cloud cover 1%.\n" \
      'Next hour: minutely weather Next 24h: hourly weather'
    end
    let(:ff_s) do
      "Summary: daily weather\n" \
      "Today: weather today! High 68F, Low 60F. 0% chance of " \
      "precipitation. Winds N 0mph.\n" \
      "Tomorrow: weather tomorrow! High 70F, Low 62F. 100% chance of " \
      "rain. Winds W 10mph.\n"
    end

    context 'given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          @response.generate(nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when called' do
      subject { @response.generate }

      it { should be_an_instance_of String }

      it { should eql "San Francisco, CA:\n\n#{fc_s}\n\n#{ff_s}" }
    end
  end
end
