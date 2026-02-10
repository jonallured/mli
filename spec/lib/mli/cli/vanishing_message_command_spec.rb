RSpec.describe Mli::Cli::VanishingMessageCommand do
  describe "create" do
    context "without required options" do
      it "exits and prints error message" do
        expected_output = "No value provided for required options '--body'\n"

        expect do
          expect do
            argument_vector = [
              "vanishing_message",
              "create"
            ]

            Mli::Cli::RootCommand.start(argument_vector)
          end.to raise_error(SystemExit)
        end.to output(expected_output).to_stderr
      end
    end

    context "with required options" do
      it "prints success message" do
        faraday_stubs.post("/api/v1/vanishing_messages") { [201, {}, ""] }
        expected_attrs = {"body" => "shhh"}
        expect(Mli::VanishingMessage).to receive(:create).with(expected_attrs).and_call_original
        expected_output = {abracadabra: "poof!"}.to_json + "\n"

        expect do
          argument_vector = [
            "vanishing_message",
            "create",
            "--body",
            "shhh"
          ]

          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end
  end
end
