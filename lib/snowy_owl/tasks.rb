require 'rake'
require_relative '../snowy_owl'

namespace :snowy_owl do
  desc 'generate digest for entire play books'
  task :generate_digest, [:play_book] do |task, args|
    play_book = args[:play_book]
    candidate_plots = SnowyOwl::Plays.generate_digest_for_play_book play_book
    output_result = candidate_plots.map do |plot|
      res = { 'plot_name' => plot['plot_name'],
        'digest' => plot['digest'],
      }
      res['parent'] = plot['parent'] if !plot['parent'].nil? && !plot['parent'].empty?
      res
    end
    File.open(play_book, 'w+') do |file|
      file.write output_result.to_yaml
    end
  end
end
