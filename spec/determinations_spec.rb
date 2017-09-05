require 'spec_helper'

describe 'determinations' do

  before do
    SnowyOwl::Determinations.determine('embedded scenario') do |name, sample_input|
      "#{sample_input} has called #{name}"
    end
    SnowyOwl::Determinations.determine('shared scenario') do |name, sample_input|
      message = determine_embedded_scenario "it's"
      "#{sample_input} has been called in #{name} after #{message}"
    end
  end

  it 'should determine the event happen' do
    extend SnowyOwl::Determinations
    message = determine_shared_scenario 'sample data'
    expect(message).to eq("sample data has been called in shared scenario after it's has called embedded scenario")
  end
end
