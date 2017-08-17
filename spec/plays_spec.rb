require 'spec_helper'

describe 'plays' do

  it 'should generate deep first list' do
    SnowyOwl.play_books_path = Dir.pwd + '/spec/fixtures/play_books/*.yml'
    plays = SnowyOwl::Plays.build_plays
    expect(plays).to match ['a1','a6','a2','a7','a3','a4','a5']
  end
end
