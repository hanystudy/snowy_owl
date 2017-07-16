require 'spec_helper'

describe 'string' do

  it 'should convert to underscore' do
    expect('sample plot'.underscore).to eq 'sample_plot'
  end
end
