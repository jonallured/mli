module Mli
  class VanishingMessages
    def self.create(attrs)
      endpoint = "/api/v1/vanishing_messages"
      response = Mli.connection.post(endpoint, attrs)
      return {error: "bad request"} unless response.success?

      {abracadabra: "poof!"}
    end
  end
end
