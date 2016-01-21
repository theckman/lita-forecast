# -*- coding: UTF-8 -*-
require 'spec_helper'

describe Lita::Handlers::Forecast, lita_handler: true do
  it { is_expected.to route_command('wx sf').to(:weather_us) }

  it { is_expected.to route_command('wc sf').to(:weather_ca) }

  describe '#default_config' do
    it 'should set an empty api key' do
      expect(Lita.config.handlers.forecast.api_key).to be_nil
    end
  end

  describe '.build_weather' do
    before do
      @l = Lita::Handlers::Forecast.new('robot')
      allow(@l)
        .to receive(:api_key).with(any_args).and_return('abc123')

      allow(@l)
        .to receive(:weather) do |r, a, u|
          "#{r} #{a} #{u}"
        end
    end

    context 'when us' do
      it 'should call the weather mixin method' do
        expect(@l.build_weather('us', 'r3s')).to eql 'r3s abc123 us'
      end
    end

    context 'when ca' do
      it 'should call the weather mixin method' do
        expect(@l.build_weather('ca', 'r3s')).to eql 'r3s abc123 ca'
      end
    end
  end

  describe '.weather_us' do
    it 'should call build_weather with the response and units' do
      allow_any_instance_of(Lita::Handlers::Forecast)
        .to receive(:build_weather) do |u, r|
          "#{u.nil?} #{r}"
        end
      send_command('wx sf')
      expect(replies.last).to eql 'false us'
    end
  end

  describe '.weather_ca' do
    it 'should call build_weather with the response and units' do
      allow_any_instance_of(Lita::Handlers::Forecast)
        .to receive(:build_weather) do |u, r|
          "#{u.nil?} #{r}"
        end
      send_command('wc sf')
      expect(replies.last).to eql 'false ca'
    end
  end

  describe '.api_key' do
    it 'should return Lita.config.handlers.forecast.api_key' do
      allow(Lita.config.handlers.forecast).to receive(:api_key)
        .and_return('')
      expect(subject.send(:api_key)).to eql ''
    end
  end

  describe '#default_config' do
    it 'should set the api_key to nil by default' do
      expect(Lita.config.handlers.forecast.api_key).to be_nil
    end
  end
end
