RSpec.describe Mli::WarmFuzzy do
  describe ".create" do
    it "posts params and returns data" do
      attrs = {
        "author" => "Your Biggest Fan",
        "received_at" => "2026-01-01T00:00:00",
        "title" => "Just Okay"
      }
      endpoint = "/api/v1/warm_fuzzies"
      expected_params = {warm_fuzzy: attrs}
      response_data = {
        "author" => "Your Biggest Fan",
        "body" => nil,
        "created_at" => "2026-02-01T00:00:00.000Z",
        "id" => 1,
        "received_at" => "2026-01-01T00:00:00.000Z",
        "title" => "Just Okay",
        "updated_at" => "2026-02-01T00:00:00.000Z"
      }
      response = double(:mock_response, body: response_data)
      expect(Mli.connection).to receive(:post).with(endpoint, expected_params).and_return(response)
      data = Mli::WarmFuzzy.create(attrs)
      expect(data).to eq response_data
    end
  end

  describe ".delete" do
    let(:id) { 1 }
    let(:endpoint) { "/api/v1/warm_fuzzies/1" }
    let(:response) { double(:mock_response, body: response_data, success?: success) }

    before do
      expect(Mli.connection).to receive(:delete).with(endpoint).and_return(response)
    end

    context "when record not found" do
      let(:response_data) { {"error" => "Couldn't find WarmFuzzy with 'id'=1"} }
      let(:success) { false }

      it "deletes to the id and returns error message" do
        data = Mli::WarmFuzzy.delete(id)
        expect(data).to eq response_data
      end
    end

    context "when record is found" do
      let(:response_data) { "" }
      let(:success) { true }

      it "deletes to the id and returns success message" do
        data = Mli::WarmFuzzy.delete(id)
        expect(data).to eq({done: :ok})
      end
    end
  end

  describe ".list" do
    it "gets the endpoint and returns list of data" do
      endpoint = "/api/v1/warm_fuzzies"
      page = 1
      expected_params = {page: page}
      response_data = [
        {
          "author" => "Your Biggest Fan",
          "body" => nil,
          "created_at" => "2026-02-01T00:00:00.000Z",
          "id" => 1,
          "received_at" => "2026-01-01T00:00:00.000Z",
          "title" => "Just Okay",
          "updated_at" => "2025-01-01T12:00:00.000Z"
        }
      ]
      response = double(:mock_response, body: response_data)
      expect(Mli.connection).to receive(:get).with(endpoint, expected_params).and_return(response)
      data = Mli::WarmFuzzy.list(page)
      expect(data).to eq response_data
    end
  end

  describe ".update" do
    it "puts the params to the id and returns data" do
      endpoint = "/api/v1/warm_fuzzies/1"
      id = 1
      attrs = {body: "You are just okay."}
      expected_params = {warm_fuzzy: attrs}
      response_data = {
        "author" => "Your Biggest Fan",
        "body" => "You are just okay.",
        "created_at" => "2026-02-01T00:00:00.000Z",
        "id" => 1,
        "received_at" => "2026-01-01T00:00:00.000Z",
        "title" => "Just Okay",
        "updated_at" => "2025-01-01T12:00:00.000Z"
      }
      response = double(:mock_response, body: response_data)
      expect(Mli.connection).to receive(:put).with(endpoint, expected_params).and_return(response)
      data = Mli::WarmFuzzy.update(id, attrs)
      expect(data).to eq response_data
    end
  end

  describe ".view" do
    it "gets the id and returns data" do
      endpoint = "/api/v1/warm_fuzzies/1"
      id = 1
      response_data = {
        "author" => "Your Biggest Fan",
        "body" => "You are just okay.",
        "created_at" => "2026-02-01T00:00:00.000Z",
        "id" => 1,
        "received_at" => "2026-01-01T00:00:00.000Z",
        "title" => "Just Okay",
        "updated_at" => "2025-01-01T12:00:00.000Z"
      }
      response = double(:mock_response, body: response_data)
      expect(Mli.connection).to receive(:get).with(endpoint).and_return(response)
      data = Mli::WarmFuzzy.view(id)
      expect(data).to eq response_data
    end
  end
end
