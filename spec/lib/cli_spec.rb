require "mli/cli"

RSpec.describe Mli::CLI do
  it "has help" do
    argument_vector = []
    expected_output = File.read("spec/fixtures/cli/help.txt")
    expect do
      Mli::CLI.start(argument_vector)
    end.to output(expected_output).to_stdout
  end
end
