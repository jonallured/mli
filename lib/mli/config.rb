module Mli
  class Config
    BASE_URL = "MLI_BASE_URL"
    CLIENT_TOKEN = "MLI_CLIENT_TOKEN"

    attr_reader :adapter_args, :base_url, :client_token, :connection

    def initialize(env, adapter_args, connection = nil)
      @adapter_args = adapter_args
      @base_url = env && env[BASE_URL]
      @client_token = env && env[CLIENT_TOKEN]
      @connection = connection
    end
  end
end
