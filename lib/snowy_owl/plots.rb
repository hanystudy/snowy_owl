module SnowyOwl
  module Plots
    class << self
      def write(plot_name, &block)
        proc = proc do |*args|
          extend SnowyOwl::Props
          extend SnowyOwl::Determinations
          instance_exec(*args, &block)
        end
        @__plots__ ||= {}
        @__plots__[plot_name] = proc
      end

      def plot(plot_name)
        @__plots__[plot_name]
      end
    end
  end
end
