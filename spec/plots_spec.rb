require 'spec_helper'

describe 'plots' do

  it 'should write plot' do
    plot_name = ''
    block = Proc.new do |name, path|
      plot_name = name
    end
    SnowyOwl::Plots.write 'sample plot', &block
    SnowyOwl::Plots.plot('sample plot').call('sample plot')
    expect(plot_name).to eq 'sample plot'
  end
end
