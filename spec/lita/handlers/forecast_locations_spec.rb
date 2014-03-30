# -*- coding: UTF-8 -*-
require 'spec_helper'

describe Lita::Handlers::ForecastLocations, lita_handler: true do

  it { routes_command('wadd place 42 42').to(:location_add) }

  it { routes_command('wadd place 42 42 theplace').to(:location_add) }

  it { routes_command('wrm place').to(:location_rm) }

  it { routes_command('wl').to(:locations) }

  describe '.saved_location_hash' do
    context 'when given a description' do
      let(:location) { ['home', '42', '42', 'my place'] }

      it 'should return a location hash with unique description' do
        l = { name: 'home', lat: '42', lng: '42', desc: 'my place' }

        expect(subject.send(:saved_location_hash, location)).to eql l
      end
    end

    context 'when not given a description' do
      let(:location) { %w(home 42 42) }

      it 'should return a location hash with the alias as the desc.' do
        l = { name: 'home', lat: '42', lng: '42', desc: 'home' }

        expect(subject.send(:saved_location_hash, location)).to eql l
      end
    end
  end

  describe '.rm_from_cache' do
    context 'when passed more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          subject.send(:rm_from_cache, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when passed less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          subject.send(:rm_from_cache)
        end.to raise_error ArgumentError
      end
    end

    context 'when passed a key, "alias:sf"' do
      before do
        allow(LitaForecast.redis).to receive(:del).and_return(nil)
      end
      it 'should call LitaForecast.redis.del to delete the key' do
        key = 'alias:sf'
        expect(LitaForecast.redis).to receive(:del).with(key).once
        expect(subject.send(:rm_from_cache, key)).to be_nil
      end
    end
  end

  describe '.add_to_cache' do
    context 'when passed more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          subject.send(:add_to_cache, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when passed less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          subject.send(:add_to_cache)
        end.to raise_error ArgumentError
      end
    end

    context 'when passed a location' do
      before do
        @l_hash = { name: 'sf', lat: 37.7830503, lng: -122.3933962 }
        allow(LitaForecast.redis).to receive(:hset).and_return(nil)
        allow(LitaForecast.redis).to receive(:pipelined).and_yield
      end

      it 'should add the keys to the cache' do
        expect(LitaForecast.redis).to receive(:hset)
          .with('alias:sf', 'lat', 37.7830503).once
        expect(LitaForecast.redis).to receive(:hset)
          .with('alias:sf', 'lng', -122.3933962).once
        subject.send(:add_to_cache, @l_hash)
      end
    end
  end

  describe '.already_exists?' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          subject.send(:alias_exists?, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          subject.send(:alias_exists?)
        end.to raise_error ArgumentError
      end
    end

    context 'when key exists' do
      before do
        @h = { desc: 'sf', lat: 37.7830503, lng: -122.3933962 }
        @key = 'alias:sf'
        allow(LitaForecast.redis).to receive(:hgetall).with(@key)
          .and_return(@h)
      end

      it 'should return true' do
        expect(subject.send(:alias_exists?, @key)).to be_truthy
      end
    end

    context 'when key does not exist' do
      before do
        @key = 'alias:toronto' # sorry Canadia
        allow(LitaForecast.redis).to receive(:hgetall).with(@key)
          .and_return({})
      end

      it 'should return true' do
        expect(subject.send(:alias_exists?, @key)).to be_falsey
      end
    end
  end

  describe '.locations' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          subject.locations(nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          subject.locations
        end.to raise_error ArgumentError
      end
    end

    context 'when aliases exist' do
      before do
        allow(LitaForecast.redis).to receive(:keys).with('alias:*')
          .and_return(%w(alias:sf alias:toronto))
      end

      it 'should return a list of aliases' do
        send_command('wl')
        expect(replies.last).to eql 'Known weather aliases: sf, toronto'
      end
    end

    context 'when aliases exist' do
      before do
        allow(LitaForecast.redis).to receive(:keys).with('alias:*')
          .and_return([])
      end

      it 'should return a list of aliases' do
        send_command('wl')
        expect(replies.last).to eql 'There are no weather aliases'
      end
    end
  end

  describe '.location_rm' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          subject.location_rm(nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          subject.location_rm
        end
      end
    end

    context 'when the alias does not exist' do
      before do
        allow_any_instance_of(Lita::Handlers::ForecastLocations)
          .to receive(:alias_exists?).with('alias:sf').and_return(false)
      end

      it 'should return that there was no alias' do
        send_command('wrm sf')
        expect(replies.last).to eql 'Alias not found'
      end
    end

    context 'when the alias exists and is removed' do
      before do
        key = 'alias:sf'
        allow_any_instance_of(Lita::Handlers::ForecastLocations)
          .to receive(:alias_exists?).with(key).and_return(true)
        allow_any_instance_of(Lita::Handlers::ForecastLocations)
          .to receive(:rm_from_cache).with(key).and_return(nil)
        allow(LitaForecast.redis).to receive(:keys).with(key)
          .and_return([])
      end

      it 'should return that there was no alias' do
        send_command('wrm sf')
        expect(replies.last).to eql 'Alias removed!'
      end
    end

    context 'when the alias exists and fails to remove' do
      before do
        key = 'alias:sf'
        allow_any_instance_of(Lita::Handlers::ForecastLocations)
          .to receive(:alias_exists?).with(key).and_return(true)
        allow_any_instance_of(Lita::Handlers::ForecastLocations)
          .to receive(:rm_from_cache).with(key).and_return(nil)
        allow(LitaForecast.redis).to receive(:keys).with(key)
          .and_return(['alias:sf'])
      end

      it 'should return that there was no alias' do
        send_command('wrm sf')
        expect(replies.last).to eql 'Somehow that failed... I need an adult!'
      end
    end
  end

  describe '.location_add' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          subject.location_add(nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          subject.location_add
        end.to raise_error ArgumentError
      end
    end

    context 'when the alias already exists' do
      before do
        allow_any_instance_of(Lita::Handlers::ForecastLocations)
          .to receive(:alias_exists?).and_return(true)
      end

      it 'should return "Already there!"' do
        send_command('wadd sf 37.7830503 -122.3933962')
        expect(replies.last).to eql 'Already there!'
      end
    end

    context 'when alias does not exist' do
      before do
        allow_any_instance_of(Lita::Handlers::ForecastLocations)
          .to receive(:alias_exists?).and_return(false)
        allow_any_instance_of(Lita::Handlers::ForecastLocations)
          .to receive(:saved_location_hash).and_return(nil)
        allow_any_instance_of(Lita::Handlers::ForecastLocations)
          .to receive(:add_to_cache).and_return(nil)
      end

      it 'should return that it was added to the cache' do
        send_command('wadd sf 37.7830503 -122.3933962')
        expect(replies.last)
          .to eql 'sf added to the cache at [37.7830503, -122.3933962]'
      end
    end
  end
end
