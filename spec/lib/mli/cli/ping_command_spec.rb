RSpec.describe Mli::Cli::PingCommand do
  describe "get" do
    it "prints server time" do
      faraday_stubs.get("/api/v1/ping") { [200, {}, "123456"] }
      expected_output = {server_time: "123456"}.to_json + "\n"

      expect do
        argument_vector = %w[get]
        Mli::Cli::PingCommand.start(argument_vector)
      end.to output(expected_output).to_stdout
    end
  end
end
