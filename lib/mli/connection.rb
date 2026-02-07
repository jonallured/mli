module Mli
  class Connection
    DEFAULT_BASE_URL = "https://app.jonallured.com/"

    class MissingClientTokenError < StandardError; end

    def self.generate(config)
      return config.connection if config.connection
      raise MissingClientTokenError unless config.client_token

      base_url = config.base_url || DEFAULT_BASE_URL
      user_agent = "Mli v#{VERSION} (Faraday v#{Faraday::VERSION})"

      headers = {
        "User-Agent" => user_agent,
        "X-MLI-CLIENT-TOKEN" => config.client_token
      }

      Faraday.new(url: base_url, headers: headers) do |f|
        f.adapter(*config.adapter_args)
        f.request :multipart
        f.request :json
        f.response :json
      end
    end
  end
end
