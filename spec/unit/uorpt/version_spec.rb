# -*- coding: UTF-8 -*-

require 'spec_helper'

describe UOrpt::VERSION do
  it { should be_an_instance_of String }

  it 'should look like a semver' do
    m = /\d+\.\d+\.\d+([0-9a-z\-\.])?+/

    expect(m.match(subject)).not_to be_nil
  end
end
