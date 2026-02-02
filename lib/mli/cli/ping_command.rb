module Mli
  module Cli
    class PingCommand < BaseCommand
      desc "get", "Get server time"
      long_desc docs_for(:ping, :get), wrap: false
      def get
        ping_data = Ping.get
        say formatted(ping_data)
      end
    end
  end
end
