require 'spec_helper'

describe 'sequence run' do

  it 'should sequence run from begin to end' do
    sequence = []
    SnowyOwl::Plots.write('user register') { sequence << 'user register' }
    SnowyOwl::Plots.write('user login') { sequence << 'user login' }
    SnowyOwl::Plots.write('user logout') { sequence << 'user logout' }
    allow(YAML).to receive(:load_file).with(play_book_path).and_return(play_book_sequence)
    SnowyOwl.play
    expect(sequence).to eq play_book_sequence.map {|plot| plot['plot_name']}
  end

  it 'should sequence run from starting point to end' do
    sequence = []
    SnowyOwl::Plots.write('user register') { sequence << 'user register' }
    SnowyOwl::Plots.write('user login') { sequence << 'user login' }
    SnowyOwl::Plots.write('user logout') { sequence << 'user logout' }
    allow(YAML).to receive(:load_file).with(play_book_path).and_return(play_book_sequence)
    ENV['PLOTS_SCOPE'] = 'user login..'
    SnowyOwl.play
    expect(sequence).to eq ['user login', 'user logout']
  end

  it 'should sequence run from starting point to ending point' do
    sequence = []
    SnowyOwl::Plots.write('user register') { sequence << 'user register' }
    SnowyOwl::Plots.write('user login') { sequence << 'user login' }
    SnowyOwl::Plots.write('user logout') { sequence << 'user logout' }
    allow(YAML).to receive(:load_file).with(play_book_path).and_return(play_book_sequence)
    ENV['PLOTS_SCOPE'] = 'user register..user login'
    SnowyOwl.play
    expect(sequence).to eq ['user register', 'user login']
  end

  before do
    SnowyOwl.configure do |config|
      config.play_books_path = play_book_path
      config.is_persisting = false
      config.is_recovering = false
    end
  end

  let(:play_book_sequence) { [{'plot_name' => 'user register'}, {'plot_name' => 'user login'}, {'plot_name' => 'user logout'}] }
  let(:play_book_path) { Dir.pwd + '/spec/fixtures/play_books/play_book.yml' }
end
