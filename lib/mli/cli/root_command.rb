module Mli
  module Cli
    class RootCommand < Thor
      desc "ping", "Work with the /api/v1/ping family of endpoints."
      subcommand "ping", PingCommand

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
