RSpec.describe Mli::Book do
  describe ".create" do
    context "with nil attrs" do
      it "returns an invalid params error" do
        api_payload = {"error" => "param is missing or the value is empty or invalid: book"}
        faraday_stubs.post("/api/v1/books") { [400, {}, api_payload] }
        attrs = nil
        book_data = Mli::Book.create(attrs)
        expect(book_data).to eq(api_payload)
      end
    end

    context "with empty attrs" do
      it "returns an invalid params error" do
        api_payload = {"error" => "param is missing or the value is empty or invalid: book"}
        faraday_stubs.post("/api/v1/books") { [400, {}, api_payload] }
        attrs = {}
        book_data = Mli::Book.create(attrs)
        expect(book_data).to eq(api_payload)
      end
    end

    context "without required attrs" do
      it "returns a validation error" do
        api_payload = {"error" => "Validation failed: Finished on can't be blank, Format is not included in the list, Isbn can't be blank"}
        faraday_stubs.post("/api/v1/books") { [400, {}, api_payload] }
        attrs = {"foo" => "bar"}
        book_data = Mli::Book.create(attrs)
        expect(book_data).to eq(api_payload)
      end
    end

    context "with required attrs" do
      it "returns book data" do
        api_payload = {
          "created_at" => "2025-01-01T00:00:00.000Z",
          "finished_on" => "2025-01-01",
          "format" => "print",
          "id" => 1,
          "isbn" => "123-456-7890",
          "pages" => nil,
          "title" => nil,
          "updated_at" => "2025-01-01T00:00:00.000Z"
        }
        faraday_stubs.post("/api/v1/books") { [201, {}, api_payload] }
        attrs = {
          "finished_on" => "2025-01-01",
          "format" => "print",
          "isbn" => "123-456-7890"
        }
        book_data = Mli::Book.create(attrs)
        expect(book_data).to eq(api_payload)
      end
    end
  end

  describe ".delete" do
    context "with a nil id" do
      it "raises a NilIdError" do
        expect do
          id = nil
          Mli::Book.delete(id)
        end.to raise_error(Mli::NilIdError)
      end
    end

    context "with an invalid id" do
      it "returns a not found error" do
        api_payload = {"error" => "Couldn't find Book with 'id'=\"invalid\""}
        faraday_stubs.delete("/api/v1/books/invalid") { [404, {}, api_payload] }
        id = "invalid"
        book_data = Mli::Book.delete(id)
        expect(book_data).to eq(api_payload)
      end
    end

    context "with a valid id" do
      it "returns done and ok" do
        faraday_stubs.delete("/api/v1/books/1") { [200, {}, ""] }
        id = 1
        book_data = Mli::Book.delete(id)
        expect(book_data).to eq({done: :ok})
      end
    end
  end

  describe ".list" do
    context "with no books" do
      it "returns an empty array" do
        api_payload = []
        faraday_stubs.get("/api/v1/books") { [200, {}, api_payload] }
        books_data = Mli::Book.list(1)
        expect(books_data).to eq(api_payload)
      end
    end

    context "with a few books" do
      it "returns array of books" do
        api_payload = [
          {
            "created_at" => "2003-03-03T00:00:00.000Z",
            "finished_on" => "2003-03-03",
            "format" => "print",
            "id" => 3,
            "isbn" => "333-333-3333",
            "pages" => nil,
            "title" => nil,
            "updated_at" => "2003-03-03T00:00:00.000Z"
          },
          {
            "created_at" => "2002-02-02T00:00:00.000Z",
            "finished_on" => "2002-02-02",
            "format" => "print",
            "id" => 2,
            "isbn" => "222-222-2222",
            "pages" => nil,
            "title" => nil,
            "updated_at" => "2002-02-02T00:00:00.000Z"
          },
          {
            "created_at" => "2001-01-01T00:00:00.000Z",
            "finished_on" => "2001-01-01",
            "format" => "print",
            "id" => 1,
            "isbn" => "111-111-1111",
            "pages" => nil,
            "title" => nil,
            "updated_at" => "2001-01-01T00:00:00.000Z"
          }
        ]
        faraday_stubs.get("/api/v1/books") { [200, {}, api_payload] }
        books_data = Mli::Book.list(1)
        expect(books_data).to eq(api_payload)
      end
    end
  end

  describe ".update" do
    context "with a nil id" do
      it "raises a NilIdError" do
        expect do
          id = nil
          attrs = nil
          Mli::Book.update(id, attrs)
        end.to raise_error(Mli::NilIdError)
      end
    end

    context "with an invalid id" do
      it "returns a not found error" do
        api_payload = {"error" => "Couldn't find Book with 'id'=\"invalid\""}
        faraday_stubs.put("/api/v1/books/invalid") { [404, {}, api_payload] }
        id = "invalid"
        attrs = nil
        book_data = Mli::Book.update(id, attrs)
        expect(book_data).to eq(api_payload)
      end
    end

    context "with nil attrs" do
      it "returns an invalid params error" do
        api_payload = {"error" => "param is missing or the value is empty or invalid: book"}
        faraday_stubs.put("/api/v1/books/1") { [400, {}, api_payload] }
        id = 1
        attrs = nil
        book_data = Mli::Book.update(id, attrs)
        expect(book_data).to eq(api_payload)
      end
    end

    context "with empty attrs" do
      it "returns an invalid params error" do
        api_payload = {"error" => "param is missing or the value is empty or invalid: book"}
        faraday_stubs.put("/api/v1/books/1") { [400, {}, api_payload] }
        id = 1
        attrs = {}
        book_data = Mli::Book.update(id, attrs)
        expect(book_data).to eq(api_payload)
      end
    end

    context "with a valid id and an attr" do
      it "returns book data" do
        api_payload = {
          "created_at" => "2025-01-01T00:00:00.000Z",
          "finished_on" => "2025-01-01",
          "format" => "audio",
          "id" => 1,
          "isbn" => "123-456-7890",
          "pages" => nil,
          "title" => nil,
          "updated_at" => "2025-01-01T00:00:00.000Z"
        }
        faraday_stubs.put("/api/v1/books/1") { [201, {}, api_payload] }
        id = 1
        attrs = {"format" => "audio"}
        book_data = Mli::Book.update(id, attrs)
        expect(book_data).to eq(api_payload)
      end
    end
  end

  describe ".view" do
    context "with a nil id" do
      it "raises a NilIdError" do
        expect do
          id = nil
          Mli::Book.view(id)
        end.to raise_error(Mli::NilIdError)
      end
    end

    context "with an invalid id" do
      it "returns a not found error" do
        api_payload = {"error" => "Couldn't find Book with 'id'=\"invalid\""}
        faraday_stubs.get("/api/v1/books/invalid") { [404, {}, api_payload] }
        id = "invalid"
        book_data = Mli::Book.view(id)
        expect(book_data).to eq(api_payload)
      end
    end

    context "with a valid id" do
      it "returns book data" do
        api_payload = {
          "created_at" => "2025-01-01T00:00:00.000Z",
          "finished_on" => "2025-01-01",
          "format" => "print",
          "id" => 1,
          "isbn" => "123-456-7890",
          "pages" => nil,
          "title" => nil,
          "updated_at" => "2025-01-01T00:00:00.000Z"
        }
        faraday_stubs.get("/api/v1/books/1") { [200, {}, api_payload] }
        id = 1
        book_data = Mli::Book.view(id)
        expect(book_data).to eq(api_payload)
      end
    end
  end
end
