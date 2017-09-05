require 'snowy_owl/rspec/rerun'

module SnowyOwl
  class Config
    alias_options = OPTIONS.dup
    alias_options << :spec_file
    remove_const :OPTIONS
    const_set :OPTIONS, alias_options.uniq

    attr_accessor :spec_file
  end

  module Plots
    class << self
      alias old_write write

      def write(plot_name, &block)
        proc = old_write plot_name, &block
        RSpec.shared_examples plot_name do |args|
          @metadata[:digest] = args[:digest]
          @metadata[:is_recovering] = args[:is_recovering]
          scenario plot_name, &proc
        end
      end
    end
  end

  def self.play(*args)
    RSpec.feature *args do
      Dir[SnowyOwl.plots_path].each { |f| require f }
      Dir[SnowyOwl.determinations_path].each { |f| require f }

      before do |plot|
        digest = plot.metadata[:digest]
        is_recovering = plot.metadata[:is_recovering]
        SnowyOwl::Persist.recover_state digest if SnowyOwl.is_recovering && is_recovering
        SnowyOwl::Persist.persist_state digest if SnowyOwl.is_persisting
      end

      candidate_play_books = Dir[SnowyOwl.play_books_path]

      owl_field = OwlField.new

      candidate_plots = SnowyOwl::Plays.build_plays(candidate_play_books)
      expression = ENV['PLOTS_SCOPE']
      candidate_plots = owl_field.plots_scope(candidate_plots, expression)
      candidate_plots.each do |plot|
        plot_name = plot['plot_name']
        digest = plot['digest']
        is_recovering = plot['is_recovering']
        it_behaves_like plot_name, digest: digest, is_recovering: is_recovering
      end
    end
  end

  class StatusFormatter
    RSpec::Core::Formatters.register self, :example_failed

    def initialize(out)
      @out = out
    end

    def example_failed(notification)
      example = notification.example
      @out.puts "\nplot name: #{example.description}"
      @out.puts "plot digest: #{example.metadata[:digest]}"
    end
  end

  RSpec.configure do |c|
    c.add_formatter 'progress'
    c.add_formatter StatusFormatter
  end
end
