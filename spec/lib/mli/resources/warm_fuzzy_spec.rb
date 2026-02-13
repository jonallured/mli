RSpec.describe Mli::WarmFuzzy do
  describe ".create" do
    context "with nil attrs" do
      it "returns an invalid params error" do
        api_payload = {"error" => "param is missing or the value is empty or invalid: warm_fuzzy"}
        faraday_stubs.post("/api/v1/warm_fuzzies") { [400, {}, api_payload] }
        attrs = nil
        warm_fuzzy_data = Mli::WarmFuzzy.create(attrs)
        expect(warm_fuzzy_data).to eq(api_payload)
      end
    end

    context "with empty attrs" do
      it "returns an invalid params error" do
        api_payload = {"error" => "param is missing or the value is empty or invalid: warm_fuzzy"}
        faraday_stubs.post("/api/v1/warm_fuzzies") { [400, {}, api_payload] }
        attrs = {}
        warm_fuzzy_data = Mli::WarmFuzzy.create(attrs)
        expect(warm_fuzzy_data).to eq(api_payload)
      end
    end

    context "without required attrs" do
      it "returns a validation error" do
        api_payload = {"error" => "Validation failed: Author can't be blank, Received at can't be blank, Title can't be blank"}
        faraday_stubs.post("/api/v1/warm_fuzzies") { [400, {}, api_payload] }
        attrs = {"foo" => "bar"}
        warm_fuzzy_data = Mli::WarmFuzzy.create(attrs)
        expect(warm_fuzzy_data).to eq(api_payload)
      end
    end

    context "with required attrs" do
      it "returns warm fuzzy data" do
        api_payload = {
          "author" => "Your Biggest Fan",
          "body" => nil,
          "created_at" => "2025-01-01T00:00:00.000Z",
          "id" => 1,
          "received_at" => "2025-01-01T00:00:00.000Z",
          "screenshot" => nil,
          "title" => "Just Okay",
          "updated_at" => "2025-01-01T00:00:00.000Z"
        }
        faraday_stubs.post("/api/v1/warm_fuzzies") { [201, {}, api_payload] }
        attrs = {
          "author" => "Your Biggest Fan",
          "received_at" => "2025-01-01T00:00:00.000Z",
          "title" => "Just Okay"
        }
        warm_fuzzy_data = Mli::WarmFuzzy.create(attrs)
        expect(warm_fuzzy_data).to eq(api_payload)
      end
    end
  end

  describe ".delete" do
    context "with a nil id" do
      it "raises a NilIdError"
    end

    context "with an invalid id" do
      it "returns a not found error"
    end

    context "with a valid id" do
      it "returns done and ok"
    end
  end

  describe ".list" do
    context "with no warm fuzzies" do
      it "returns an empty array"
    end

    context "with a few warm fuzzies" do
      it "returns array of warm fuzzies"
    end
  end

  describe ".update" do
    context "with a nil id" do
      it "raises a NilIdError"
    end

    context "with an invalid id" do
      it "returns a not found error"
    end

    context "with nil attrs" do
      it "returns an invalid params error"
    end

    context "with empty attrs" do
      it "returns an invalid params error"
    end

    context "with a valid id and an attr" do
      it "returns warm fuzzy data"
    end
  end

  describe ".view" do
    context "with a nil id" do
      it "raises a NilIdError"
    end

    context "with an invalid id" do
      it "returns a not found error"
    end

    context "with a valid id" do
      it "returns warm fuzzy data"
    end
  end
end
