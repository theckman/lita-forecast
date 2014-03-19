# -*- coding: UTF-8 -*-
require 'spec_helper'

describe LitaForecast::VERSION do
  it { should be_an_instance_of String }

  it 'should match a version string' do
    m = /^\d+\.\d+\.\d+$/
    expect(m.match(subject)).to_not be_nil
  end
end
