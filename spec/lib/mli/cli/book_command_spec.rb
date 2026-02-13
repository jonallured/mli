RSpec.describe Mli::Cli::BookCommand do
  describe "create" do
    context "without required options" do
      it "exits and prints error message"
    end

    context "with required options" do
      it "prints book data"
    end
  end

  describe "delete" do
    context "without an id" do
      it "exits and prints error message"
    end

    context "with valid id" do
      it "prints done"
    end
  end

  describe "list" do
    context "with no books" do
      it "prints empty array"
    end

    context "with a few books" do
      it "prints array of book data"
    end
  end

  describe "update" do
    context "without an id" do
      it "exits and prints error message"
    end

    context "without an option" do
      it "exits and prints error message"
    end

    context "with valid id and an option" do
      it "prints book data"
    end
  end

  describe "view" do
    context "without an id" do
      it "exits and prints error message"
    end

    context "with valid id" do
      it "prints book data"
    end
  end
end
