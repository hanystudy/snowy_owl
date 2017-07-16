require 'spec_helper'

describe 'determinations' do

  before do
    SnowyOwl::Determinations.determine('shared scenario') { |name, sample_input| "#{sample_input} has been called in #{name}" }
  end

  it 'should determine the event happen' do
    extend SnowyOwl::Determinations
    message = determine_shared_scenario 'sample data'
    expect(message).to eq('sample data has been called in shared scenario')
  end
end
