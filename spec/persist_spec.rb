require 'spec_helper'

describe 'persist' do

  it 'should persist state' do
    plot_name_path = ''
    persist_path = ''
    block = Proc.new do |name_path, path|
      plot_name_path = name_path
      persist_path = path
    end
    SnowyOwl.persist_callback &block
    allow(FileUtils).to receive(:mkdir_p).and_return ''
    SnowyOwl::Persist.persist_state 'sample plot'
    expect(plot_name_path).to eq 'sample_plot'
    expect(persist_path).to eq '/.tmp/sample_plot'
  end

  it 'should recover state' do
    plot_name_path = ''
    recover_path = ''
    block = Proc.new do |name_path, path|
      plot_name_path = name_path
      recover_path = path
    end
    SnowyOwl.recover_callback &block
    SnowyOwl::Persist.recover_state 'sample plot'
    expect(plot_name_path).to eq 'sample_plot'
    expect(recover_path).to eq 'sample_plot'
  end
end
