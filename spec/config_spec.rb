require 'spec_helper'

describe 'config' do

  before do
    SnowyOwl.configure do |config|
      config.props_path = '/path/to/props'
      config.determine_context :context_key, &proc
      config.determinations_path = ''
      config.plots_path = ''
      config.play_books_path = ''
      config.is_persisting = false
      config.is_recovering = false
      config.persist_path = ''
      config.persist_callback &proc
      config.recover_callback  &proc
    end
  end

  it 'should allow configure setting' do
    expect(SnowyOwl.props_path).to eq '/path/to/props'
    expect(SnowyOwl.determine_context :context_key).to eq(proc)
    expect(SnowyOwl.determinations_path).to eq ''
    expect(SnowyOwl.plots_path).to eq ''
    expect(SnowyOwl.play_books_path).to eq ''
    expect(SnowyOwl.is_persisting).to eq false
    expect(SnowyOwl.is_recovering).to eq false
    expect(SnowyOwl.persist_path).to eq ''
    expect(SnowyOwl.recover_callback).to eq(proc)
    expect(SnowyOwl.persist_callback).to eq(proc)
  end

  it 'should allow direct setting' do
    SnowyOwl.props_path = '/new_path/to/props'
    SnowyOwl.determine_context :context_key, &replacement_proc
    SnowyOwl.determinations_path = ''
    SnowyOwl.plots_path = ''
    SnowyOwl.play_books_path = ''
    SnowyOwl.is_persisting = false
    SnowyOwl.is_recovering = false
    SnowyOwl.persist_path = ''
    SnowyOwl.persist_callback &replacement_proc
    SnowyOwl.recover_callback  &replacement_proc
    expect(SnowyOwl.props_path).to eq '/new_path/to/props'
    expect(SnowyOwl.determine_context :context_key).to eq(replacement_proc)
    expect(SnowyOwl.determinations_path).to eq ''
    expect(SnowyOwl.plots_path).to eq ''
    expect(SnowyOwl.play_books_path).to eq ''
    expect(SnowyOwl.is_persisting).to eq false
    expect(SnowyOwl.is_recovering).to eq false
    expect(SnowyOwl.persist_path).to eq ''
    expect(SnowyOwl.recover_callback).to eq(replacement_proc)
    expect(SnowyOwl.persist_callback).to eq(replacement_proc)
  end

  let(:proc) { Proc.new {} }
  let(:replacement_proc) { Proc.new {} }
end
