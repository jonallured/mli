RSpec.describe Mli::Cli::BaseCommand do
  describe ".attrs_for" do
    context "with nil args" do
      it "returns an empty hash" do
        args = nil
        attrs = Mli::Cli::BaseCommand.attrs_for(args)
        expect(attrs).to eq({})
      end
    end

    context "with empty args" do
      it "returns an empty hash" do
        args = nil
        attrs = Mli::Cli::BaseCommand.attrs_for(args)
        expect(attrs).to eq({})
      end
    end

    context "with invalid args" do
      it "returns an empty hash" do
        args = %w[invalid]
        attrs = Mli::Cli::BaseCommand.attrs_for(args)
        expect(attrs).to eq({})
      end
    end

    context "with malformed args" do
      it "returns an empty hash" do
        args = %w[malformed:]
        attrs = Mli::Cli::BaseCommand.attrs_for(args)
        expect(attrs).to eq({})
      end
    end

    context "with valid args" do
      it "returns a hash with those key/value pairs" do
        args = %w[first_name:jon last_name:allured]
        attrs = Mli::Cli::BaseCommand.attrs_for(args)
        expect(attrs).to eq({
          "first_name" => "jon",
          "last_name" => "allured"
        })
      end
    end
  end

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
        allow(File).to receive(:read).with("docs/found.txt").and_return(found_doc_data)
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
end
