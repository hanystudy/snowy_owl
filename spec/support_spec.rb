require 'spec_helper'

describe 'support' do

  it 'should convert to underscore' do
    expect(SnowyOwl::Support.to_underscore 'sample plot').to eq 'sample_plot'
  end
end
