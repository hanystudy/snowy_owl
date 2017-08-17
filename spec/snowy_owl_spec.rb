require 'spec_helper'

describe 'sequence run' do

  it 'should sequence run from begin to end' do
    sequence = []
    SnowyOwl::Plots.write('get up') { sequence << 'get up' }
    SnowyOwl::Plots.write('wash face') { sequence << 'wash face' }
    SnowyOwl::Plots.write('leave home') { sequence << 'leave home' }
    allow(YAML).to receive(:load_file).with(play_book_path).and_return(play_book_sequence)
    SnowyOwl.play
    expect(sequence).to eq play_book_sequence.map {|plot| plot['plot_name']}
  end

  it 'should sequence run from starting point to end' do
    sequence = []
    SnowyOwl::Plots.write('get up') { sequence << 'get up' }
    SnowyOwl::Plots.write('wash face') { sequence << 'wash face' }
    SnowyOwl::Plots.write('leave home') { sequence << 'leave home' }
    allow(YAML).to receive(:load_file).with(play_book_path).and_return(play_book_sequence)
    ENV['PLOTS_SCOPE'] = 'get up..'
    SnowyOwl.play
    expect(sequence).to eq ['get up', 'wash face', 'leave home']
  end

  it 'should sequence run from starting point to ending point' do
    sequence = []
    SnowyOwl::Plots.write('get up') { sequence << 'get up' }
    SnowyOwl::Plots.write('wash face') { sequence << 'wash face' }
    SnowyOwl::Plots.write('leave home') { sequence << 'leave home' }
    allow(YAML).to receive(:load_file).with(play_book_path).and_return(play_book_sequence)
    ENV['PLOTS_SCOPE'] = 'wash face..leave home'
    SnowyOwl.play
    expect(sequence).to eq ['wash face', 'leave home']
  end

  before do
    SnowyOwl.configure do |config|
      config.play_books_path = play_book_path
      config.is_persisting = false
      config.is_recovering = false
    end
  end

  let(:play_book_sequence) { [{'plot_name' => 'get up'}, {'plot_name' => 'wash face'}, {'plot_name' => 'leave home'}] }
  let(:play_book_path) { Dir.pwd + '/spec/fixtures/play_books/go_to_work.yml' }
end
