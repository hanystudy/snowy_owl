require 'forwardable'
require 'yaml'
require 'snowy_owl/string'
require 'snowy_owl/config'

module SnowyOwl
  class OwlField
    def play *args, &block
      instance_exec *args, &block
    end

    def sequence_run candidate_play_books
      candidate_play_books.each do |play_book|
        candidate_plots = YAML.load_file(play_book)
        plots_scope = ENV['PLOTS_SCOPE']
        unless plots_scope.nil?
          SnowyOwl.is_recovering = true
          scope = plots_scope.split("\n")
          candidate_plots = candidate_plots.select {|plot| scope.include? plot['plot_name']}
        end
        candidate_plots.each do |plot|
          plot_name = plot['plot_name']
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
