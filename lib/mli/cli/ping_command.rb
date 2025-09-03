module Mli
  module Cli
    class PingCommand < BaseCommand
      desc "get", "Get server time"
      long_desc docs_for(:ping, :get), wrap: false
      def get
        server_time = Ping.get
        say formatted(server_time)
      end

      private

      def formatted(data)
        return data unless options["pretty"]

        JSON.pretty_generate({server_time: data})
      end
    end
  end
end
