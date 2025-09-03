RSpec.describe Mli::Cli::RootCommand do
  describe "version" do
    context "with no arguments" do
      let(:argument_vector) { [] }

      it "prints help text" do
        expected_output = File.read("spec/fixtures/cli/help.txt")

        expect do
          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end

    context "with version command" do
      let(:argument_vector) { %w[version] }

      it "prints version" do
        expected_output = Mli::VERSION + "\n"

        expect do
          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end
  end
end
