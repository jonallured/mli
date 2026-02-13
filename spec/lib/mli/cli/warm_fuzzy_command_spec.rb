RSpec.describe Mli::Cli::WarmFuzzyCommand do
  describe "create" do
    context "without required options" do
      it "exits and prints error message"
    end

    context "with required options" do
      it "sends api call and prints created data"
    end

    context "with all options" do
      it "sends api call with all options and prints created data"
    end
  end

  describe "delete" do
    context "without required argument" do
      it "exits and prints error message"
    end

    context "when record not found" do
      it "prints not found error"
    end

    context "when record is found" do
      it "prints done"
    end
  end

  describe "list" do
    context "with no records" do
      it "prints empty array"
    end

    context "with no records for a given page" do
      it "requests that page and prints empty array"
    end

    context "with a few records" do
      it "prints those records"
    end
  end

  describe "update" do
    context "without required argument" do
      it "exits and prints error message"
    end

    context "with no options" do
      it "prints missing error"
    end

    context "when record not found" do
      it "prints not found error"
    end

    context "with an option" do
      it "prints updated data"
    end
  end

  describe "view" do
    context "when record not found" do
      it "prints not found error"
    end

    context "when record is found" do
      it "prints warmfuzzy data"
    end
  end
end
