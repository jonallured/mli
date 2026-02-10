module Mli
  module Cli
    class PingCommand < BaseCommand
      desc "get", "Get server time"
      long_desc docs_for(:ping, :get), wrap: false
      def get
        data = Ping.get
        say formatted(data)
      end
    end
  end
end
