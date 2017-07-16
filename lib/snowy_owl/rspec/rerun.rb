require 'rspec-rerun/tasks'

module RSpec
  module Rerun
    class Formatter
      def retry_command(example)
        example.description
      end
    end

    module Tasks
      class << self
        def spec_files
          File.read(RSpec::Rerun::Formatter::FILENAME)
        end

        def failing_specs
          [SnowyOwl.spec_file]
        end

        def failed_count
          spec_files.split("\n").count
        end

        def rerun(args)
          ENV['PLOTS_SCOPE'] = spec_files
          Rake::Task['rspec-rerun:rerun'].execute(args)
        end
      end
    end
  end
end
