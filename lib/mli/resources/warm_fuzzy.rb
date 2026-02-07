module Mli
  class WarmFuzzy
    def self.create(attrs)
      endpoint = "/api/v1/warm_fuzzies"
      params = Mli::ParamBuilder.from(warm_fuzzy: attrs)
      response = Mli.connection.post(endpoint, params)
      response.body
    end

    def self.delete(id)
      endpoint = "/api/v1/warm_fuzzies/#{id}"
      response = Mli.connection.delete(endpoint)
      return response.body unless response.success?

      {done: :ok}
    end

    def self.list(page)
      endpoint = "/api/v1/warm_fuzzies"
      params = Mli::ParamBuilder.from(page: page)
      response = Mli.connection.get(endpoint, params)
      response.body
    end

    def self.update(id, attrs)
      endpoint = "/api/v1/warm_fuzzies/#{id}"
      params = Mli::ParamBuilder.from(warm_fuzzy: attrs)
      response = Mli.connection.put(endpoint, params)
      response.body
    end

    def self.view(id)
      endpoint = "/api/v1/warm_fuzzies/#{id}"
      response = Mli.connection.get(endpoint)
      response.body
    end
  end
end
