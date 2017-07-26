module SnowyOwl
  class Config
    OPTIONS = %i[
      props_path
      determine_context
      determinations_path
      play_books_path
      is_persisting
      is_recovering
      persist_path
      plots_path
      persist_callback
      recover_callback
      spec_file
    ].freeze

    attr_accessor :props_path, :determinations_path, :play_books_path
    attr_accessor :is_persisting, :is_recovering, :persist_path, :plots_path
    attr_accessor :spec_file

    def determine_context(key, &determine_block)
      @determine_context ||= {}
      if block_given?
        @determine_context[key] = determine_block
      else
        @determine_context[key]
      end
    end

    def persist_callback(&block)
      @persist_callback = block || @persist_callback
    end

    def recover_callback(&block)
      @recover_callback = block || @recover_callback
    end
  end
end
