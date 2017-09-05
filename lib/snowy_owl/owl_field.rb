module SnowyOwl
  class OwlField
    def play(*args, &block)
      instance_exec *args, &block
    end

    def plots_scope(candidate_plots, expression)
      return candidate_plots if expression.nil? || expression.empty?
      SnowyOwl.is_recovering = true
      plots_range = expression.match /(.*)(\.{2})(.*)/
      if plots_range.nil?
        scope = expression.split("\n")
        candidate_plots.select do |plot|
          in_scope = scope.include?(plot['plot_name']) || scope.include?(plot['digest'])
          plot['is_recovering'] = in_scope
          in_scope
        end
      else
        sequence_run_from_starting_point candidate_plots, plots_range
      end
    end

    def sequence_run_from_starting_point(candidate_plots, plots_range)
      starting_point = plots_range[1]
      range_type = plots_range[2]
      ending_point = plots_range[3]
      in_scope = false
      candidate_plots.each_with_object([]) do |plot, acc|
        plot_name = plot['plot_name']
        plot_digest = plot['digest']
        in_scope = true if plot_name == starting_point || plot_digest == starting_point
        if in_scope
          plot['is_recovering'] = acc.size == 0
          acc << plot
        end
        in_scope = false if plot_name == ending_point || plot_digest == ending_point
      end
    end

    def sequence_run(candidate_play_books)
      candidate_plots = SnowyOwl::Plays.build_plays(candidate_play_books)
      expression = ENV['PLOTS_SCOPE']
      candidate_plots = plots_scope(candidate_plots, expression)
      candidate_plots.each do |plot|
        plot_name = plot['plot_name']
        digest = plot['digest']
        is_recovering = plot['is_recovering']
        SnowyOwl::Persist.recover_state digest if SnowyOwl.is_recovering && is_recovering
        SnowyOwl::Persist.persist_state digest if SnowyOwl.is_persisting
        instance_exec plot_name, &SnowyOwl::Plots.plot(plot_name)
      end
    end
  end
end
