require 'spec_helper'

describe 'props' do

  it 'should load props' do
    SnowyOwl.props_path = Dir.pwd + '/spec/fixtures/props/*.yml'
    plot_name = ''
    data_value = ''
    block = Proc.new do |name, path|
      plot_name = name
      data_value = data.value
    end
    SnowyOwl::Plots.write 'sample plot', &block
    SnowyOwl::Plots.plot('sample plot').call('sample plot')
    expect(plot_name).to eq 'sample plot'
    expect(data_value).to eq 'sample data value'
  end
end
