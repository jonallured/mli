RSpec.describe Mli::WarmFuzzy do
  describe ".create" do
    context "with nil attrs" do
      it "returns an invalid params error"
    end

    context "with empty attrs" do
      it "returns an invalid params error"
    end

    context "without required attrs" do
      it "returns a validation error"
    end

    context "with required attrs" do
      it "returns warm fuzzy data"
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
