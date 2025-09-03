RSpec.describe Mli::Cli::VanishingMessagesCommand do
  describe "create" do
    let(:error_response) { [400, {}, ""] }
    let(:success_response) { [201, {}, ""] }

    before do
      faraday_stubs.post("/api/v1/vanishing_messages") { api_response }
    end

    context "without required attr" do
      let(:api_response) { error_response }
      let(:argument_vector) { %w[create] }

      it "prints error message" do
        expected_output = {error: "bad request"}.to_json + "\n"

        expect do
          Mli::Cli::VanishingMessagesCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end

    context "with required attr" do
      let(:api_response) { success_response }
      let(:argument_vector) { %w[create body:shhh] }

      it "prints success message" do
        expected_output = {abracadabra: "poof!"}.to_json + "\n"

        expect do
          Mli::Cli::VanishingMessagesCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end
  end
end
