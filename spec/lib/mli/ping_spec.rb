RSpec.describe Mli::Ping do
  describe ".get" do
    it "gets the ping endpoint and returns server time as string" do
      endpoint = "/api/v1/ping"
      response = double(:mock_response, body: "123456")
      expect(Mli.connection).to receive(:get).with(endpoint).and_return(response)
      server_time = Mli::Ping.get
      expect(server_time).to eq "123456"
    end
  end
end
