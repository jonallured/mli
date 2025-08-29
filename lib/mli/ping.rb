module Mli
  class Ping
    def self.get
      endpoint = "/api/v1/ping"
      response = Mli.connection.get(endpoint)
      response.body
    end
  end
end
