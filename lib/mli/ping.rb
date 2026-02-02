module Mli
  class Ping
    def self.get
      endpoint = "/api/v1/ping"
      response = Mli.connection.get(endpoint)
      server_time = response.body
      {server_time: server_time}
    end
  end
end
