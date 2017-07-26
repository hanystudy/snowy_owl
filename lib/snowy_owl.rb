require 'forwardable'
require 'yaml'
require 'snowy_owl/support'
require 'snowy_owl/config'

module SnowyOwl
  class << self
    extend Forwardable

    SnowyOwl::Config::OPTIONS.each do |method|
      def_delegators :config, "#{method}=", "#{method}="
      def_delegators :config, method, method
    end

    def configure
      yield config
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
require 'snowy_owl/owl_field'
