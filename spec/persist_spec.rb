require 'spec_helper'

describe 'persist' do

  it 'should persist state' do
    name_path = ''
    persist_path = ''
    block = Proc.new do |sub_path, path|
      name_path = sub_path
      persist_path = path
    end
    SnowyOwl.persist_callback &block
    allow(FileUtils).to receive(:mkdir_p).and_return ''
    SnowyOwl::Persist.persist_state digest
    expect(name_path).to eq digest
    expect(persist_path).to eq '/.tmp/'
  end

  it 'should recover state' do
    name_path = ''
    recover_path = ''
    block = Proc.new do |sub_path, path|
      name_path = sub_path
      recover_path = path
    end
    SnowyOwl.recover_callback &block
    SnowyOwl::Persist.recover_state digest
    expect(name_path).to eq digest
    expect(recover_path).to eq ''
  end

  let(:digest) { '8151325dcdbae9e0ff95f9f9658432dbedfdb209' }
end
