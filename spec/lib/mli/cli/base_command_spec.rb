RSpec.describe Mli::Cli::BaseCommand do
  describe ".docs_for" do
    context "with a missing topic" do
      let(:topic) { :missing }
      let(:section) { :found }

      it "raises an error" do
        expect do
          Mli::Cli::BaseCommand.docs_for(topic, section)
        end.to raise_error(Errno::ENOENT)
      end
    end

    context "with a found topic" do
      let(:topic) { :found }

      before do
        found_doc_data = File.read("spec/fixtures/cli/doc.txt")
        expect(File).to receive(:read).with(match("docs/found.txt")).and_return(found_doc_data)
      end

      context "with a missing section" do
        let(:section) { :missing }

        it "returns nil" do
          doc_data = Mli::Cli::BaseCommand.docs_for(topic, section)
          expect(doc_data).to be_nil
        end
      end

      context "with found section" do
        let(:section) { :found }

        it "returns that doc data" do
          doc_data = Mli::Cli::BaseCommand.docs_for(topic, section)
          expect(doc_data).to eq "  GET /api/v1/found"
        end
      end
    end
  end

  describe "#formatted" do
    context "without the pretty option" do
      it "returns normal JSON" do
        base_command = Mli::Cli::BaseCommand.new
        dummy_data = {foo: :bar}
        formatted = base_command.formatted(dummy_data)
        expect(formatted).to eq '{"foo":"bar"}'
      end
    end

    context "with the pretty option" do
      it "returns pretty JSON" do
        base_command = Mli::Cli::BaseCommand.new([], %w[--pretty], {})
        dummy_data = {foo: :bar}
        formatted = base_command.formatted(dummy_data)

        expect(formatted).to eq(<<~JSON.chomp)
          {
            "foo": "bar"
          }
        JSON
      end
    end
  end
end
