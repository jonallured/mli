RSpec.describe Mli::Connection do
  describe ".generate" do
    let(:config) do
      env = {
        "MLI_BASE_URL" => base_url,
        "MLI_CLIENT_TOKEN" => client_token
      }
      adapter_args = [Faraday.default_adapter]
      Mli::Config.new(env, adapter_args)
    end

    context "with no client token" do
      let(:base_url) { nil }
      let(:client_token) { nil }

      it "raises an error" do
        expect do
          Mli::Connection.generate(config)
        end.to raise_error(Mli::Connection::MissingClientTokenError)
      end
    end

    context "with a client token and no other config" do
      let(:base_url) { nil }
      let(:client_token) { "shhh" }

      it "returns a connection with default settings" do
        connection = Mli::Connection.generate(config)

        expect(connection.adapter).to eq Faraday::Adapter::NetHttp
        expect(connection.url_prefix.to_s).to eq Mli::Connection::DEFAULT_BASE_URL

        handlers = connection.builder.handlers
        expect(handlers).to eq [Faraday::Request::Json, Faraday::Response::Json]

        headers = connection.headers
        expect(headers["User-Agent"]).to eq "Mli v#{Mli::VERSION} (Faraday v#{Faraday::VERSION})"
        expect(headers["X-MLI-CLIENT-TOKEN"]).to eq "shhh"
      end
    end

    context "with a base url" do
      let(:base_url) { "http://localhost:3007/" }
      let(:client_token) { "shhh" }

      it "returns a connection that uses that base url" do
        connection = Mli::Connection.generate(config)
        expect(connection.url_prefix.to_s).to eq "http://localhost:3007/"
      end
    end

    context "with a connection in the config" do
      let(:mock_connection) { double(:mock_connection) }

      let(:config) do
        env = {}
        adapter_args = []
        Mli::Config.new(env, adapter_args, mock_connection)
      end

      it "returns that connection from the config" do
        connection = Mli::Connection.generate(config)
        expect(connection).to eq mock_connection
      end
    end
  end
end
