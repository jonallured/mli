RSpec.describe Mli::Config do
  context "with no settings" do
    it "returns a config with nil settings" do
      config = Mli::Config.new(nil, nil, nil)

      expect(config.adapter_args).to be_nil
      expect(config.base_url).to be_nil
      expect(config.client_token).to be_nil
      expect(config.connection).to be_nil
    end
  end

  context "with all the settings" do
    it "returns a config with those settings" do
      env = {
        "MLI_BASE_URL" => "http://localhost:3007/",
        "MLI_CLIENT_TOKEN" => "shhh"
      }
      adapter_args = [:foo, :bar]
      mock_connection = double(:mock_connection)

      config = Mli::Config.new(env, adapter_args, mock_connection)

      expect(config.adapter_args).to eq([:foo, :bar])
      expect(config.base_url).to eq "http://localhost:3007/"
      expect(config.client_token).to eq "shhh"
      expect(config.connection).to eq mock_connection
    end
  end

  context "with missing keys in env" do
    it "returns a config with nil for those keys" do
      config = Mli::Config.new({}, nil, nil)

      expect(config.base_url).to be_nil
      expect(config.client_token).to be_nil
    end
  end
end
