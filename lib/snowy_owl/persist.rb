require 'json'
require 'ostruct'
require 'fileutils'

module SnowyOwl
  module Persist

    class << self
      def persist_state(plot_name)
        plot_name_path = plot_name.underscore
        path = SnowyOwl.persist_path + '/.tmp/' + plot_name_path
        FileUtils::mkdir_p path
        args = [plot_name, path]
        SnowyOwl.persist_callback.call(args)
      end

      def recover_state(plot_name)
        plot_name_path = plot_name.underscore
        path = SnowyOwl.persist_path + plot_name_path
        args = [plot_name, path]
        SnowyOwl.recover_callback.call(args)
      end
    end
  end
end
