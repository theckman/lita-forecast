# -*- coding: UTF-8 -*-
require 'spec_helper'
require 'redis-namespace'

describe LitaForecast do
  describe '::FORECAST_NAMESPACE' do
    subject { LitaForecast::FORECAST_NAMESPACE }

    it { should be_an_instance_of String }

    it { should eql 'handlers:forecast' }
  end

  describe '.redis' do
    it 'should not take any args' do
      expect do
        LitaForecast.redis(nil)
      end.to raise_error ArgumentError
    end

    context 'under normal conditions' do
      subject { LitaForecast.redis }

      it { should be_an_instance_of Redis::Namespace }
    end
  end
end
