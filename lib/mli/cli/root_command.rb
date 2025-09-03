module Mli
  module Cli
    class RootCommand < Thor
      desc "ping", "Use /api/v1/ping endpoint family"
      subcommand "ping", PingCommand

      desc "vanishing_messages", "Use /api/v1/vanishing_messages endpoint family"
      subcommand "vanishing_messages", VanishingMessagesCommand

      desc "version", "Print the version number"
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
