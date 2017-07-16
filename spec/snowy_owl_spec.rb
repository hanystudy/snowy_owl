require 'spec_helper'

describe 'sequence run' do

  before do
    SnowyOwl.configure do |config|
      config.props_path = Dir.pwd + '/spec/fixtures/props/*.yml'
      config.determinations_path = Dir.pwd + '/spec/fixtures/determinations/*.rb'
      config.plots_path = Dir.pwd + '/spec/fixtures/plots/*.rb'
      config.play_books_path = Dir.pwd + '/spec/fixtures/play_books/*.yml'
      config.is_persisting = false
      config.is_recovering = false
    end
  end

  it 'should sequence run' do
    class String
      def self.catch_test_string args
      end
    end
    expect(String).to receive(:catch_test_string).with 'sample data value'
    SnowyOwl.play
  end
end
