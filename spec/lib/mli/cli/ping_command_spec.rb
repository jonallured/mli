RSpec.describe Mli::Cli::PingCommand do
  describe "get" do
    before do
      faraday_stubs.get("/api/v1/ping") { [200, {}, "123456"] }
    end

    context "with no flags" do
      let(:argument_vector) { %w[get] }

      it "prints server time in plain text" do
        expected_output = "123456\n"

        expect do
          Mli::Cli::PingCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end

    context "with pretty flag" do
      let(:argument_vector) { %w[get --pretty] }

      it "prints server time in pretty format" do
        expected_output = <<~JSON
          {
            "server_time": "123456"
          }
        JSON

        expect do
          Mli::Cli::PingCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end
  end
end
