require 'json'
require 'ostruct'

module SnowyOwl
  module Determinations
    def self.determine(name, &block)
      SnowyOwl.determine_context SnowyOwl::Support.to_underscore(name).to_sym, &block
    end

    def method_missing(name, *args, &block)
      context_key = name.to_s.gsub /determine_/, ''
      determine_context = SnowyOwl.determine_context context_key.downcase.to_sym
      if determine_context.nil?
        super(name, *args, &block)
      else
        args.unshift context_key.tr('_', ' ')
        instance_exec(*args, &determine_context)
      end
    end
  end
end
