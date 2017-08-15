require 'json'
require 'ostruct'
require 'fileutils'

module SnowyOwl
  module Persist
    class << self
      def persist_state(digest)
        temp_persist_path = SnowyOwl.persist_path + '/.tmp/'
        sub_path = digest
        path = temp_persist_path + sub_path
        FileUtils.mkdir_p path
        args = [sub_path, temp_persist_path]
        SnowyOwl.persist_callback.call(args)
      end

      def recover_state(digest)
        sub_path = digest
        args = [sub_path, SnowyOwl.persist_path]
        SnowyOwl.recover_callback.call(args)
      end
    end
  end
end
