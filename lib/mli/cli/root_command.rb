module Mli
  module Cli
    class RootCommand < Thor
      desc "version", "Print the version number."
      def version
        say Mli::VERSION
      end

      def self.basename
        "mli"
      end

      def self.exit_on_failure?
        true
      end
    end
  end
end
