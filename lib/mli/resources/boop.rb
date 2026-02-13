module Mli
  class Boop
    def self.create(attrs)
      endpoint = "/api/v1/boops"
      boop_params = Mli::ParamBuilder.from(attrs)
      params = {boop: boop_params}
      response = Mli.connection.post(endpoint, params)
      response.body
    end

    def self.delete(id)
      endpoint = "/api/v1/boops/#{id}"
      response = Mli.connection.delete(endpoint)
      return response.body unless response.success?

      {done: :ok}
    end

    def self.list(page)
      endpoint = "/api/v1/boops"
      params = {page: page}
      response = Mli.connection.get(endpoint, params)
      response.body
    end

    def self.update(id, attrs)
      endpoint = "/api/v1/boops/#{id}"
      boop_params = Mli::ParamBuilder.from(attrs)
      params = {boop: boop_params}
      response = Mli.connection.put(endpoint, params)
      response.body
    end

    def self.view(id)
      endpoint = "/api/v1/boops/#{id}"
      response = Mli.connection.get(endpoint)
      response.body
    end
  end
end
