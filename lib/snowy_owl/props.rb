require 'json'
require 'ostruct'
require 'yaml'

module SnowyOwl
  module Props
    def init_props
      props_path = SnowyOwl.props_path
      raise 'Invalid props path' if props_path.empty?
      props_hash = {}
      Dir[props_path].each do |f|
        field_name = File.basename f, '.yml'
        props_hash[field_name] = YAML.load_file(f)
      end
      @__props__ = JSON.parse(props_hash.to_json, object_class: OpenStruct)
    end

    def method_missing(name, *args, &block)
      @__props__ ||= init_props
      return @__props__.send name if @__props__.respond_to? name
      super name, *args, &block
    end
  end
end
