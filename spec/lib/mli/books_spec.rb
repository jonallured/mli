RSpec.describe Mli::Books do
  describe ".create" do
    it "posts attrs and returns book data" do
      endpoint = "/api/v1/books"
      book_attrs = {
        "finished_on" => "2025-01-01",
        "format" => "print",
        "isbn" => "123-456-789"
      }
      response_data = {
        "created_at" => "2025-01-01T12:00:00.000Z",
        "finished_on" => "2025-01-01",
        "format" => "print",
        "id" => 1,
        "isbn" => "123-456-789",
        "pages" => nil,
        "title" => nil,
        "updated_at" => "2025-01-01T12:00:00.000Z"
      }
      response = double(:mock_response, body: response_data)
      expect(Mli.connection).to receive(:post).with(endpoint, book: book_attrs).and_return(response)
      book_data = Mli::Books.create(book_attrs)
      expect(book_data).to eq response_data
    end
  end

  describe ".delete" do
    let(:book_id) { 1 }
    let(:endpoint) { "/api/v1/books/1" }
    let(:response) { double(:mock_response, body: response_data, success?: success) }

    before do
      expect(Mli.connection).to receive(:delete).with(endpoint).and_return(response)
    end

    context "when record not found" do
      let(:response_data) { {"error" => "Couldn't find Book with 'id'=1"} }
      let(:success) { false }

      it "deletes to the id and returns error message" do
        book_data = Mli::Books.delete(book_id)
        expect(book_data).to eq response_data
      end
    end

    context "when record is found" do
      let(:response_data) { "" }
      let(:success) { true }

      it "deletes to the id and returns success message" do
        book_data = Mli::Books.delete(book_id)
        expect(book_data).to eq({done: :ok})
      end
    end
  end

  describe ".list" do
    it "gets the endpoint and returns list of book data" do
      endpoint = "/api/v1/books"
      response_data = [
        {
          "created_at" => "2025-01-01T12:00:00.000Z",
          "finished_on" => "2025-01-01",
          "format" => "print",
          "id" => 1,
          "isbn" => "123-456-789",
          "pages" => nil,
          "title" => nil,
          "updated_at" => "2025-01-01T12:00:00.000Z"
        }
      ]
      response = double(:mock_response, body: response_data)
      expect(Mli.connection).to receive(:get).with(endpoint).and_return(response)
      book_data = Mli::Books.list
      expect(book_data).to eq response_data
    end
  end

  describe ".update" do
    it "puts the attrs to the id and returns book data" do
      endpoint = "/api/v1/books/1"
      book_id = 1
      book_attrs = {"pages" => "77"}
      response_data = {
        "created_at" => "2025-01-01T12:00:00.000Z",
        "finished_on" => "2025-01-01",
        "format" => "print",
        "id" => 1,
        "isbn" => "123-456-789",
        "pages" => 77,
        "title" => nil,
        "updated_at" => "2025-01-01T12:00:00.000Z"
      }
      response = double(:mock_response, body: response_data)
      expect(Mli.connection).to receive(:put).with(endpoint, book: book_attrs).and_return(response)
      book_data = Mli::Books.update(book_id, book_attrs)
      expect(book_data).to eq response_data
    end
  end

  describe ".view" do
    it "gets the id and returns book data" do
      endpoint = "/api/v1/books/1"
      book_id = 1
      response_data = {
        "created_at" => "2025-01-01T12:00:00.000Z",
        "finished_on" => "2025-01-01",
        "format" => "print",
        "id" => 1,
        "isbn" => "123-456-789",
        "pages" => 77,
        "title" => "best book",
        "updated_at" => "2025-01-01T12:00:00.000Z"
      }
      response = double(:mock_response, body: response_data)
      expect(Mli.connection).to receive(:get).with(endpoint).and_return(response)
      book_data = Mli::Books.view(book_id)
      expect(book_data).to eq response_data
    end
  end
end
