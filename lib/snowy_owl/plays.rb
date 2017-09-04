module SnowyOwl
  module Plays
    class PlotNodeHash
      attr_accessor :children, :digest, :parent, :name

      def initialize
        @children = []
      end

      def append_child(digest)
        @children << digest
      end

      def to_h
        {'digest' => @digest,
         'parent' => @parent,
         'plot_name' => @name }
      end
    end

    class << self
      def build_plays(candidate_play_books)
        @play_hash = {}
        @starting_node = nil
        candidate_play_books.each { |play_book| generate_digest_for_play_book play_book }
        generate_deep_first_plays
      end

      def generate_digest_for_play_book play_book
        @play_hash ||= {}
        candidate_plots = YAML.load_file(play_book)
        generate_full_path_digest(candidate_plots)
      end

      def generate_deep_first_plays
        plays = []
        deep_stack = [@starting_node.digest]
        while !deep_stack.empty?
          node = deep_stack.pop
          deep_stack = deep_stack.concat @play_hash[node].children
          plays << @play_hash[node].to_h
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
        plot_node = @play_hash[plot['digest']] || PlotNodeHash.new
        plot_node.name = plot['plot_name']
        plot_node.parent = plot['parent']
        plot_node.digest = plot['digest']
        @play_hash[plot['digest']] = plot_node
        if !plot['parent'].nil?
          parent_node = @play_hash[plot['parent']] || PlotNodeHash.new
          plot_node.parent = plot['parent']
          parent_node.append_child plot['digest']
          @play_hash[plot['parent']] = parent_node
        end
        @play_hash[plot['digest']]
      end
    end
  end
end
