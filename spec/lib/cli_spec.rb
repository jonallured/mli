require "mli/cli"

RSpec.describe Mli::CLI do
  context "with no arguments" do
    let(:argument_vector) { [] }

    it "prints the help text" do
      expected_output = File.read("spec/fixtures/cli/help.txt")
      expect do
        Mli::CLI.start(argument_vector)
      end.to output(expected_output).to_stdout
    end
  end

  context "with version command" do
    let(:argument_vector) { ["version"] }

    it "prints the version" do
      expected_output = Mli::VERSION + "\n"
      expect do
        Mli::CLI.start(argument_vector)
      end.to output(expected_output).to_stdout
    end
  end
end
