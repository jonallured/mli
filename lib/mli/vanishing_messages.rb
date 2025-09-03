module Mli
  class VanishingMessages
    def self.create(attrs)
      endpoint = "/api/v1/vanishing_messages"
      response = Mli.connection.post(endpoint, attrs)

      return {error: "bad request"} if response.status == 400

      {abracadabra: "poof!"}
    end
  end
end
