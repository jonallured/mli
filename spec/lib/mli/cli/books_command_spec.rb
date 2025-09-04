RSpec.describe Mli::Cli::BooksCommand do
  describe "create" do
    before do
      faraday_stubs.post("/api/v1/books") { [api_status, {}, api_payload] }
    end

    context "with no attrs" do
      let(:api_payload) do
        {"error" => "param is missing or the value is empty or invalid: book"}
      end

      let(:api_status) { 400 }
      let(:argument_vector) { %w[create] }

      it "prints missing error" do
        expected_output = api_payload.to_json + "\n"

        expect do
          Mli::Cli::BooksCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end

    context "without required attrs" do
      let(:api_payload) do
        {"error" => "Validation failed: Finished on can't be blank, Format is not included in the list, Isbn can't be blank"}
      end

      let(:api_status) { 400 }
      let(:argument_vector) { %w[create foo:bar] }

      it "prints validation error" do
        expected_output = api_payload.to_json + "\n"

        expect do
          Mli::Cli::BooksCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end

    context "with required attrs" do
      let(:api_payload) do
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
      end

      let(:api_status) { 201 }
      let(:argument_vector) { %w[create finished_on:2025-01-01 format:print isbn:123-456-789] }

      it "prints created book data" do
        expected_output = api_payload.to_json + "\n"

        expect do
          Mli::Cli::BooksCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end
  end

  describe "delete" do
    let(:argument_vector) { %w[delete 1] }

    before do
      faraday_stubs.delete("/api/v1/books/1") { [api_status, {}, api_payload] }
    end

    context "when record not found" do
      let(:api_payload) do
        {"error" => "Couldn't find Book with 'id'=1"}
      end

      let(:api_status) { 404 }

      it "prints not found error" do
        expected_output = api_payload.to_json + "\n"

        expect do
          Mli::Cli::BooksCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end

    context "when record is found" do
      let(:api_payload) { "" }
      let(:api_status) { 200 }

      it "prints done" do
        expected_output = {done: :ok}.to_json + "\n"

        expect do
          Mli::Cli::BooksCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end
  end

  describe "list" do
    let(:api_status) { 200 }
    let(:argument_vector) { %w[list] }

    before do
      faraday_stubs.get("/api/v1/books") { [api_status, {}, api_payload] }
    end

    context "with no records" do
      let(:api_payload) { [] }

      it "prints empty array" do
        expected_output = api_payload.to_json + "\n"

        expect do
          Mli::Cli::BooksCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end

    context "with no records for a given page" do
      let(:api_payload) { [] }
      let(:argument_vector) { %w[list 7] }

      it "prints empty array" do
        expected_output = api_payload.to_json + "\n"

        expect do
          Mli::Cli::BooksCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end

    context "with a few records" do
      let(:api_payload) do
        [
          {
            "created_at" => "2003-03-03T03:33:33.333Z",
            "finished_on" => "2003-03-03",
            "format" => "print",
            "id" => 3,
            "isbn" => "333-333-333",
            "pages" => 333,
            "title" => "third book",
            "updated_at" => "2003-03-03T03:33:33.333Z"
          },
          {
            "created_at" => "2002-02-02T02:22:22.222Z",
            "finished_on" => "2022-02-02",
            "format" => "print",
            "id" => 2,
            "isbn" => "222-222-222",
            "pages" => 222,
            "title" => "second book",
            "updated_at" => "2002-02-02T02:22:22.222Z"
          },
          {
            "created_at" => "2001-01-01T01:11:11.111Z",
            "finished_on" => "2001-01-01",
            "format" => "print",
            "id" => 1,
            "isbn" => "111-111-111",
            "pages" => 111,
            "title" => "first book",
            "updated_at" => "2001-01-01T01:11:11.111Z"
          }
        ]
      end

      it "prints those records" do
        expected_output = api_payload.to_json + "\n"

        expect do
          Mli::Cli::BooksCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end
  end

  describe "update" do
    before do
      faraday_stubs.put("/api/v1/books/1") { [api_status, {}, api_payload] }
    end

    context "with no attrs" do
      let(:api_payload) do
        {"error" => "param is missing or the value is empty or invalid: book"}
      end

      let(:api_status) { 400 }
      let(:argument_vector) { %w[update 1] }

      it "prints missing error" do
        expected_output = api_payload.to_json + "\n"

        expect do
          Mli::Cli::BooksCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end

    context "when record not found" do
      let(:api_payload) do
        {"error" => "Couldn't find Book with 'id'=1"}
      end

      let(:api_status) { 404 }
      let(:argument_vector) { %w[update 1 pages:77] }

      it "prints not found error" do
        expected_output = api_payload.to_json + "\n"

        expect do
          Mli::Cli::BooksCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end

    context "with an attr" do
      let(:api_payload) do
        {
          "created_at" => "2025-01-01T12:00:00.000Z",
          "finished_on" => "2025-01-01",
          "format" => "print",
          "id" => 1,
          "isbn" => "123-456-789",
          "pages" => 77,
          "title" => nil,
          "updated_at" => "2025-01-01T13:00:00.000Z"
        }
      end

      let(:api_status) { 200 }
      let(:argument_vector) { %w[update 1 pages:77] }

      it "prints updated book data" do
        expected_output = api_payload.to_json + "\n"

        expect do
          Mli::Cli::BooksCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end
  end

  describe "view" do
    let(:argument_vector) { %w[view 1] }

    before do
      faraday_stubs.get("/api/v1/books/1") { [api_status, {}, api_payload] }
    end

    context "when record not found" do
      let(:api_payload) do
        {"error" => "Couldn't find Book with 'id'=1"}
      end

      let(:api_status) { 404 }

      it "prints not found error" do
        expected_output = api_payload.to_json + "\n"

        expect do
          Mli::Cli::BooksCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end

    context "when record is found" do
      let(:api_payload) do
        {
          "created_at" => "2025-01-01T12:00:00.000Z",
          "finished_on" => "2025-01-01",
          "format" => "print",
          "id" => 1,
          "isbn" => "123-456-789",
          "pages" => 77,
          "title" => "best book",
          "updated_at" => "2025-01-01T13:00:00.000Z"
        }
      end

      let(:api_status) { 200 }

      it "prints book data" do
        expected_output = api_payload.to_json + "\n"

        expect do
          Mli::Cli::BooksCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end
  end
end
