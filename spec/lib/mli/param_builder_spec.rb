RSpec.describe Mli::ParamBuilder do
  describe ".content_type_for" do
    context "with a filename without extension" do
      it "returns nil" do
        filename = nil
        content_type = Mli::ParamBuilder.content_type_for(filename)
        expect(content_type).to eq nil
      end
    end

    context "with a known extension" do
      it "returns the content type for that extension" do
        filename = "test.png"
        content_type = Mli::ParamBuilder.content_type_for(filename)
        expect(content_type).to eq "image/png"
      end
    end

    context "with an unknown extension" do
      it "returns nil" do
        filename = "test.mp3"
        content_type = Mli::ParamBuilder.content_type_for(filename)
        expect(content_type).to eq nil
      end
    end
  end

  describe ".from" do
    context "with nil attrs" do
      it "returns an empty hash" do
        attrs = nil
        params = Mli::ParamBuilder.from(attrs)
        expect(params).to eq({})
      end
    end

    context "with empty attrs" do
      it "returns an empty hash" do
        attrs = {}
        params = Mli::ParamBuilder.from(attrs)
        expect(params).to eq({})
      end
    end

    context "with a regular attr" do
      it "returns that regular attr" do
        attrs = {regular: "attribute"}
        params = Mli::ParamBuilder.from(attrs)
        expect(params).to eq({regular: "attribute"})
      end
    end

    context "with a value of nil for a regular attr" do
      it "ignores that attr" do
        attrs = {regular: nil}
        params = Mli::ParamBuilder.from(attrs)
        expect(params).to eq({})
      end
    end

    context "with a date attr" do
      it "returns that date attr" do
        attrs = {completed_on: "2025-01-01"}
        params = Mli::ParamBuilder.from(attrs)
        expect(params).to eq({completed_on: "2025-01-01"})
      end
    end

    context "with a value of today for a date attr" do
      it "returns today's date for that attr" do
        attrs = {completed_on: "today"}
        as_of = Time.at(0).utc
        params = Mli::ParamBuilder.from(attrs, as_of)
        expect(params).to eq({completed_on: "1970-01-01"})
      end
    end

    context "with a time attr" do
      it "returns that time attr" do
        attrs = {completed_at: "2025-01-01T07:00:00Z"}
        params = Mli::ParamBuilder.from(attrs)
        expect(params).to eq({completed_at: "2025-01-01T07:00:00Z"})
      end
    end

    context "with a value of now for a time attr" do
      it "returns now's time for that attr" do
        attrs = {completed_at: "now"}
        as_of = Time.at(0).utc
        params = Mli::ParamBuilder.from(attrs, as_of)
        expect(params).to eq({completed_at: "1970-01-01T00:00:00Z"})
      end
    end

    context "with a path attr" do
      it "renames that attr and returns a FilePart for the value" do
        attrs = {file_path: "spec/fixtures/code.png"}
        params = Mli::ParamBuilder.from(attrs)
        file_param = params[:file]
        expect(file_param.class).to eq Faraday::Multipart::FilePart
      end
    end
  end
end
