require 'digest'

module SnowyOwl
  module Digest
    def self.generate_full_path_digest(candidate_plots)
      candidate_plots.each_with_object([]) do |plot, plots_path|
        plots_path = [*plots_path, plot['plot_name']]
        full_path = plots_path.join "\n"
        plot['digest'] = ::Digest::SHA1.hexdigest full_path
        plots_path
      end
      candidate_plots
    end
  end
end
