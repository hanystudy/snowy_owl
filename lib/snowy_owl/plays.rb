module SnowyOwl
  module Plays
    class PlotNodeHash
      attr_accessor :children, :digest, :parent

      def initialize(digest, parent = nil)
        @digest = digest
        @parent = parent
        @children = []
      end

      def append_child(digest)
        @children << digest
      end
    end

    class << self
      def build_plays
        @play_hash = {}
        @starting_node = nil
        candidate_play_books = Dir[SnowyOwl.play_books_path]
        candidate_play_books.each do |play_book|
          candidate_plots = YAML.load_file(play_book)
          generate_full_path_digest(candidate_plots)
        end
        generate_deep_first_plays
      end

      def generate_deep_first_plays
        plays = []
        deep_stack = [@starting_node.digest]
        while !deep_stack.empty?
          node = deep_stack.pop
          deep_stack = deep_stack.concat @play_hash[node].children
          plays << node
        end
        plays
      end

      def generate_full_path_digest(candidate_plots)
        pre_digest = nil
        candidate_plots.each do |plot|
          parent_digest = plot['parent']
          digest = plot['digest']
          plot['digest'] = SnowyOwl::Digest.digest((parent_digest || pre_digest).to_s + plot['plot_name']) if digest.nil?
          plot['parent'] = pre_digest if parent_digest.nil?
          pre_digest = plot['digest']
          node = create_node plot
          @starting_node = node if node.parent.nil?
        end
        candidate_plots
      end

      def create_node plot
        plot_node = @play_hash[plot['digest']] || PlotNodeHash.new(plot['digest'], plot['parent'])
        @play_hash[plot['digest']] = plot_node
        if !plot['parent'].nil?
          parent_node = @play_hash[plot['parent']] || PlotNodeHash.new(plot['parent'])
          plot_node.parent = plot['parent']
          parent_node.append_child plot['digest']
          @play_hash[plot['parent']] = parent_node
        end
        @play_hash[plot['digest']]
      end
    end
  end
end
