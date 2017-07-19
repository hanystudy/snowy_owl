require 'forwardable'
require 'yaml'
require 'snowy_owl/support'
require 'snowy_owl/config'

module SnowyOwl
  class OwlField
    def play *args, &block
      instance_exec *args, &block
    end

    def plots_scope candidate_plots, expression
      return candidate_plots if expression.nil?
      SnowyOwl.is_recovering = true
      plots_range = expression.match /(.*)(\.{2})(.*)/
      unless plots_range.nil?
        sequence_run_from_starting_point candidate_plots, plots_range
      else
        scope = plots_scope.split("\n")
        candidate_plots = candidate_plots.select {|plot| scope.include? plot['plot_name']}
      end
    end

    def sequence_run_from_starting_point candidate_plots, plots_range
      starting_point = plots_range[1]
      range_type = plots_range[2]
      ending_point = plots_range[3]
      in_scope = false
      candidate_plots.inject([]) do |acc, plot|
        plot_name = plot['plot_name']
        in_scope = true if plot_name == starting_point
        acc << plot if in_scope
        in_scope = false if plot_name == ending_point
        acc
      end
    end

    def sequence_run candidate_play_books
      candidate_play_books.each do |play_book|
        candidate_plots = YAML.load_file(play_book)
        expression = ENV['PLOTS_SCOPE']
        candidate_plots = plots_scope candidate_plots, expression
        candidate_plots.each do |plot|
          plot_name = plot['plot_name']
          SnowyOwl::Persist.recover_state plot_name if SnowyOwl.is_recovering
          SnowyOwl::Persist.persist_state plot_name if SnowyOwl.is_persisting
          instance_exec plot_name, &SnowyOwl::Plots.plot(plot_name)
        end
      end
    end
  end

  class << self
    extend Forwardable

    SnowyOwl::Config::OPTIONS.each do |method|
      def_delegators :config, "#{method}=" , "#{method}="
      def_delegators :config, method, method
    end

    def configure
      yield self.config
    end

    def config
      @config ||= SnowyOwl::Config.new
    end

    def play
      owl_field = OwlField.new
      owl_field.play 'Snowy Owl' do
        Dir[SnowyOwl.plots_path].each { |f| require f }
        Dir[SnowyOwl.determinations_path].each { |f| require f }
        sequence_run Dir[SnowyOwl.play_books_path]
      end
    end
  end
end

SnowyOwl.configure do |config|
  config.props_path = ''
  config.determinations_path = ''
  config.plots_path = ''
  config.play_books_path = ''
  config.is_persisting = false
  config.is_recovering = false
  config.persist_path = ''
end

require 'snowy_owl/persist'
require 'snowy_owl/plots'
require 'snowy_owl/props'
require 'snowy_owl/determinations'
