RSpec.describe Mli::Cli::VanishingMessageCommand do
  describe "create" do
    let(:error_response) { [400, {}, ""] }
    let(:success_response) { [201, {}, ""] }

    before do
      faraday_stubs.post("/api/v1/vanishing_messages") { api_response }
    end

    context "with required options" do
      let(:api_response) { success_response }
      let(:argument_vector) { %w[create --body shhh] }

      it "prints success message" do
        expected_output = {abracadabra: "poof!"}.to_json + "\n"

        expect do
          Mli::Cli::VanishingMessageCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end
  end
end
