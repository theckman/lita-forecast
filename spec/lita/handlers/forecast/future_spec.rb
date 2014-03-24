# -*- coding: UTF-8 -*-
require 'spec_helper'

describe LitaForecast::Future do
  let(:forecast) do
    {
      'flags' => { 'units' => 'us' },
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
      }
    }
  end

  before do
    @future = LitaForecast::Future.new(forecast)
  end

  describe '#new' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          LitaForecast::Future.new(nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          LitaForecast::Future.new
        end.to raise_error ArgumentError
      end
    end

    context 'when passed a ForecastIO-like response' do
      subject { LitaForecast::Future.new(forecast) }

      it { should be_an_instance_of LitaForecast::Future }

      it 'should set the ForecastIO-like object to the @f variable' do
        i = subject.instance_variable_get(:@f)
        expect(i).to eql forecast
      end
    end
  end

  describe '.daily' do
    context 'when passed more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          @future.send(:daily, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when called' do
      subject { @future.send(:daily) }

      it { should be_an_instance_of Array }

      it { should eql forecast['daily']['data'] }
    end
  end

  describe '.generate_summary' do
    context 'when passed more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          @future.send(:generate_summary, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when called' do
      subject { @future.send(:generate_summary) }

      it { should be_an_instance_of String }

      it { should eql "Summary: daily weather\n" }
    end
  end

  describe '.summary' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          @future.send(:summary, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when called' do
      before do
        @future.instance_variable_set(:@i, forecast['daily']['data'][0])
        @future.instance_variable_set(:@d, 'Today')
      end

      subject { @future.send(:summary) }

      it { should be_an_instance_of String }

      it { should eql 'Today: weather today!' }
    end
  end

  describe '.high_low' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          @future.send(:high_low, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when called' do
      before do
        @future.instance_variable_set(:@i, forecast['daily']['data'][0])
        @future.instance_variable_set(:@d, 'Today')
      end
      let(:good_string) { 'High 68F, Low 60F.' }

      subject { @future.send(:high_low) }

      it { should be_an_instance_of String }

      it { should eql good_string }
    end
  end

  describe '.precip' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          @future.send(:precip, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when called with no preciptType' do
      before do
        @future.instance_variable_set(:@i, forecast['daily']['data'][0])
      end

      subject { @future.send(:precip) }

      it { should be_an_instance_of String }

      it { should eql '0% chance of precipitation.' }
    end

    context 'when called with a precipType' do
      before do
        @future.instance_variable_set(:@i, forecast['daily']['data'][1])
      end

      subject { @future.send(:precip) }

      it { should be_an_instance_of String }

      it { should eql '100% chance of rain.' }
    end
  end

  describe '.wind' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          @future.send(:wind, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when called' do
      before do
        @future.instance_variable_set(:@i, forecast['daily']['data'][0])
      end

      subject { @future.send(:wind) }

      it { should be_an_instance_of String }

      it { should eql 'Winds N 0mph.' }
    end
  end

  describe '.generate_day' do
    context 'when given more than two args' do
      it 'should raise ArgumentError' do
        expect do
          @future.send(:generate_day, nil, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than two args' do
      it 'should raise ArgumentError' do
        expect do
          @future.send(:generate_day, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when index is 0 and day is Today' do
      let(:good_string) do
        "Today: weather today! High 68F, Low 60F. 0% chance of " \
        "precipitation. Winds N 0mph.\n"
      end
      subject { @future.send(:generate_day, 0, 'Today') }

      it { should be_an_instance_of String }

      it { should eql good_string }
    end
  end
end
