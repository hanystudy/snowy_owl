require 'spec_helper'

describe 'persist' do

  it 'should persist state' do
    plot_name = ''
    persist_path = ''
    block = Proc.new do |name, path|
      plot_name = name
      persist_path = path
    end
    SnowyOwl.persist_callback &block
    allow(FileUtils).to receive(:mkdir_p).and_return ''
    SnowyOwl::Persist.persist_state 'sample plot'
    expect(plot_name).to eq 'sample plot'
    expect(persist_path).to eq '/.tmp/sample_plot'
  end

  it 'should recover state' do
    plot_name = ''
    recover_path = ''
    block = Proc.new do |name, path|
      plot_name = name
      recover_path = path
    end
    SnowyOwl.recover_callback &block
    SnowyOwl::Persist.recover_state 'sample plot'
    expect(plot_name).to eq 'sample plot'
    expect(recover_path).to eq 'sample_plot'
  end
end
