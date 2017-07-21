require 'snowy_owl/rspec/rerun'

module SnowyOwl
  class Config
    alias_options = OPTIONS
    alias_options << :spec_file
    remove_const :OPTIONS
    const_set :OPTIONS, alias_options.uniq

    attr_accessor :spec_file
  end

  module Plots
    class << self
      alias :old_write :write

      def write(plot_name, &block)
        proc = old_write plot_name, &block
        RSpec.shared_examples plot_name do
          scenario plot_name, &proc
        end
      end
    end
  end

  def self.play *args
    RSpec.feature *args do
      Dir[SnowyOwl.plots_path].each { |f| require f }
      Dir[SnowyOwl.determinations_path].each { |f| require f }

      before do |plot|
        SnowyOwl::Persist.recover_state plot.description if SnowyOwl.is_recovering
        SnowyOwl::Persist.persist_state plot.description if SnowyOwl.is_persisting
      end

      candidate_play_books = Dir[SnowyOwl.play_books_path]

      owl_field = OwlField.new

      candidate_play_books.each do |play_book|
        candidate_plots = YAML.load_file(play_book)
        expression = ENV['PLOTS_SCOPE']
        candidate_plots = owl_field.plots_scope candidate_plots, expression
        candidate_plots.each do |plot|
          it_behaves_like plot['plot_name']
        end
      end
    end
  end
end
