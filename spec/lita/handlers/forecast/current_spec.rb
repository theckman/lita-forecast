# -*- coding: UTF-8 -*-
require 'spec_helper'

describe LitaForecast::Current do
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
      'minutely' => { 'summary' => 'minutely weather' },
      'hourly' => { 'summary' => 'hourly weather' },
      'flags' => { 'units' => 'us' }
    }
  end
  let(:current) { LitaForecast::Current.new(forecast) }

  describe '#new' do
    context 'when given more than one arg' do
      it 'should raise error ArgumentError' do
        expect do
          LitaForecast::Current.new(nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise error ArgumentError' do
        expect do
          LitaForecast::Current.new
        end.to raise_error ArgumentError
      end
    end

    context 'when provided valid arguments' do
      subject { LitaForecast::Current.new(forecast) }

      it { should be_an_instance_of LitaForecast::Current }

      it 'should set the f instance variable' do
        expect(subject.instance_variable_get(:@f)).to eql forecast
      end
    end
  end

  describe '.currently' do
    context 'when given one arg' do
      it 'should raise error ArgumentError' do
        expect do
          current.send(:currently, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when passed no args' do
      subject { current.send(:currently) }

      it { should be_an_instance_of Hash }

      it { should eql forecast['currently'] }
    end
  end

  describe '.temp' do
    context 'when given one arg' do
      it 'should raise error ArgumentError' do
        expect do
          current.send(:temp, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when passed no args' do
      subject { current.send(:temp) }
      let(:temp) { '100.1F' }

      it { should be_an_instance_of String }

      it { should eql temp }
    end
  end

  describe '.feels' do
    context 'when given one arg' do
      it 'should raise error ArgumentError' do
        expect do
          current.send(:feels, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when passed no args' do
      subject { current.send(:feels) }
      let(:feels) { '102.1F' }

      it { should be_an_instance_of String }

      it { should eql feels }
    end
  end

  describe '.wind' do
    context 'when given one arg' do
      it 'should raise error ArgumentError' do
        expect do
          current.send(:wind, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when passed no args' do
      subject { current.send(:wind) }
      let(:wind) { 'N 5.1mph' }

      it { should be_an_instance_of String }

      it { should eql wind }
    end
  end

  describe '.humidity' do
    context 'when given one arg' do
      it 'should raise error ArgumentError' do
        expect do
          current.send(:humidity, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when passed no args' do
      subject { current.send(:humidity) }
      let(:humidity) { '10%' }

      it { should be_an_instance_of String }

      it { should eql humidity }
    end
  end

  describe '.dew_pt' do
    context 'when given one arg' do
      it 'should raise error ArgumentError' do
        expect do
          current.send(:dew_pt, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when passed no args' do
      subject { current.send(:dew_pt) }
      let(:dew_pt) { '20.1F' }

      it { should be_an_instance_of String }

      it { should eql dew_pt }
    end
  end

  describe '.pressure' do
    context 'when given one arg' do
      it 'should raise error ArgumentError' do
        expect do
          current.send(:pressure, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when passed no args' do
      subject { current.send(:pressure) }
      let(:pressure) { '1020.1mb' }

      it { should be_an_instance_of String }

      it { should eql pressure }
    end
  end

  describe '.clouds' do
    context 'when given one arg' do
      it 'should raise error ArgumentError' do
        expect do
          current.send(:clouds, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when passed no args' do
      subject { current.send(:clouds) }
      let(:clouds) { '1%' } # these clouds are the 1%... (horrible joke) //TH

      it { should be_an_instance_of String }

      it { should eql clouds }
    end
  end

  describe '.next_hour' do
    context 'when given one arg' do
      it 'should raise error ArgumentError' do
        expect do
          current.send(:next_hour, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when passed no args' do
      subject { current.send(:next_hour) }
      let(:next_hour) { 'minutely weather' }

      it { should be_an_instance_of String }

      it { should eql next_hour }
    end
  end

  describe '.today' do
    context 'when given one arg' do
      it 'should raise error ArgumentError' do
        expect do
          current.send(:today, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when passed no args' do
      subject { current.send(:today) }
      let(:today) { 'hourly weather' }

      it { should be_an_instance_of String }

      it { should eql today }
    end
  end

  describe '.conditions' do
    subject { LitaForecast::Current.new(forecast).conditions }
    let(:fc_string) do
      '100.1F (feels like 102.1F) weather; Winds N 5.1mph; Humidity 10%; ' \
      "Dew Pt 20.1F; Pressure 1020.1mb; Cloud cover 1%.\n" \
      'Next hour: minutely weather Next 24h: hourly weather'
    end

    context 'when given one arg' do
      it 'should raise error ArgumentError' do
        expect do
          LitaForecast::Current.new(forecast).conditions(nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when called with no args' do
      it { should be_an_instance_of String }

      it { should eql fc_string }
    end
  end
end
