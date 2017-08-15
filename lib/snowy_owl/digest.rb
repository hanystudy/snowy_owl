require 'digest'

module SnowyOwl
  module Digest
    def self.generate_full_path_digest(candidate_plots)
      pre_digest = nil
      candidate_plots.each do |plot|
        pre_digest = pre_digest.nil? ? digest(plot['plot_name']) : digest(pre_digest + plot['plot_name'])
        plot['digest'] = pre_digest
      end
      candidate_plots
    end

    def self.digest string
      ::Digest::SHA1.hexdigest string
    end
  end
end
