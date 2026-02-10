RSpec.describe Mli::Cli::BookCommand do
  describe "create" do
    context "without required options" do
      it "exits and prints error message" do
        expected_output = "No value provided for required options '--finished-on', '--format', '--isbn'\n"

        expect do
          expect do
            argument_vector = [
              "book",
              "create"
            ]

            Mli::Cli::RootCommand.start(argument_vector)
          end.to raise_error(SystemExit)
        end.to output(expected_output).to_stderr
      end
    end

    context "with required options" do
      it "sends api call and prints created data" do
        api_payload = {
          "created_at" => "2025-01-01T12:00:00.000Z",
          "finished_on" => "2025-01-01",
          "format" => "print",
          "id" => 1,
          "isbn" => "123-456-789",
          "pages" => nil,
          "title" => nil,
          "updated_at" => "2025-01-01T12:00:00.000Z"
        }

        faraday_stubs.post("/api/v1/books") { [201, {}, api_payload] }

        expected_attrs = {
          "finished_on" => "2025-01-01",
          "format" => "print",
          "isbn" => "123-456-789"
        }
        expect(Mli::Book).to receive(:create).with(expected_attrs).and_call_original

        expected_output = api_payload.to_json + "\n"

        expect do
          argument_vector = [
            "book",
            "create",
            "--finished_on",
            "2025-01-01",
            "--format",
            "print",
            "--isbn",
            "123-456-789"
          ]

          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end

    context "with all options" do
      it "sends api call with all options and prints created data" do
        api_payload = {
          "created_at" => "2025-01-01T12:00:00.000Z",
          "finished_on" => "2025-01-01",
          "format" => "print",
          "id" => 1,
          "isbn" => "123-456-789",
          "pages" => 77,
          "title" => "Very Good Book",
          "updated_at" => "2025-01-01T12:00:00.000Z"
        }

        faraday_stubs.post("/api/v1/books") { [201, {}, api_payload] }

        expected_attrs = {
          "finished_on" => "2025-01-01",
          "format" => "print",
          "isbn" => "123-456-789",
          "pages" => 77,
          "title" => "Very Good Book"
        }

        expect(Mli::Book).to receive(:create).with(expected_attrs).and_call_original

        expected_output = api_payload.to_json + "\n"

        expect do
          argument_vector = [
            "book",
            "create",
            "--finished_on",
            "2025-01-01",
            "--format",
            "print",
            "--isbn",
            "123-456-789",
            "--pages",
            "77",
            "--title",
            "Very Good Book"
          ]

          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end
  end

  describe "delete" do
    context "without required argument" do
      it "exits and prints error message" do
        expected_output = <<~ERR
          ERROR: "mli book delete" was called with no arguments
          Usage: "mli book delete ID"
        ERR

        expect do
          expect do
            argument_vector = [
              "book",
              "delete"
            ]

            Mli::Cli::RootCommand.start(argument_vector)
          end.to raise_error(SystemExit)
        end.to output(expected_output).to_stderr
      end
    end

    context "when record not found" do
      it "prints not found error" do
        api_payload = {"error" => "Couldn't find Book with 'id'=invalid"}
        faraday_stubs.delete("/api/v1/books/invalid") { [404, {}, api_payload] }
        expect(Mli::Book).to receive(:delete).with("invalid").and_call_original
        expected_output = api_payload.to_json + "\n"

        expect do
          argument_vector = [
            "book",
            "delete",
            "invalid"
          ]

          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end

    context "when record is found" do
      it "prints done" do
        faraday_stubs.delete("/api/v1/books/1") { [200, {}, ""] }
        expect(Mli::Book).to receive(:delete).with("1").and_call_original
        expected_output = {done: :ok}.to_json + "\n"

        expect do
          argument_vector = [
            "book",
            "delete",
            "1"
          ]

          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end
  end

  describe "list" do
    context "with no records" do
      it "prints empty array" do
        api_payload = []
        faraday_stubs.get("/api/v1/books") { [200, {}, api_payload] }
        expect(Mli::Book).to receive(:list).with(1).and_call_original
        expected_output = api_payload.to_json + "\n"

        expect do
          argument_vector = [
            "book",
            "list"
          ]

          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end

    context "with no records for a given page" do
      it "requests that page and prints empty array" do
        api_payload = []
        faraday_stubs.get("/api/v1/books") { [200, {}, api_payload] }
        expect(Mli::Book).to receive(:list).with(7).and_call_original
        expected_output = api_payload.to_json + "\n"

        expect do
          argument_vector = [
            "book",
            "list",
            "--page",
            "7"
          ]

          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end

    context "with a few records" do
      it "prints those records" do
        api_payload = [
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

        faraday_stubs.get("/api/v1/books") { [200, {}, api_payload] }
        expect(Mli::Book).to receive(:list).with(1).and_call_original
        expected_output = api_payload.to_json + "\n"

        expect do
          argument_vector = [
            "book",
            "list"
          ]

          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end
  end

  describe "update" do
    context "without required argument" do
      it "exits and prints error message" do
        expected_output = <<~ERR
          ERROR: "mli book update" was called with no arguments
          Usage: "mli book update ID"
        ERR

        expect do
          expect do
            argument_vector = [
              "book",
              "update"
            ]

            Mli::Cli::RootCommand.start(argument_vector)
          end.to raise_error(SystemExit)
        end.to output(expected_output).to_stderr
      end
    end

    context "with no options" do
      it "prints missing error" do
        api_payload = {"error" => "param is missing or the value is empty or invalid: book"}
        faraday_stubs.put("/api/v1/books/1") { [400, {}, api_payload] }
        expected_output = api_payload.to_json + "\n"

        expect do
          argument_vector = [
            "book",
            "update",
            "1"
          ]

          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end

    context "when record not found" do
      it "prints not found error" do
        api_payload = {"error" => "Couldn't find Book with 'id'=invalid"}
        faraday_stubs.put("/api/v1/books/invalid") { [404, {}, api_payload] }
        expected_attrs = {"pages" => 77}
        expect(Mli::Book).to receive(:update).with("invalid", expected_attrs).and_call_original
        expected_output = api_payload.to_json + "\n"

        expect do
          argument_vector = [
            "book",
            "update",
            "invalid",
            "--pages",
            "77"
          ]

          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end

    context "with an option" do
      it "prints updated data" do
        api_payload = {
          "created_at" => "2025-01-01T12:00:00.000Z",
          "finished_on" => "2025-01-01",
          "format" => "print",
          "id" => 1,
          "isbn" => "123-456-789",
          "pages" => 77,
          "title" => nil,
          "updated_at" => "2025-01-01T13:00:00.000Z"
        }

        faraday_stubs.put("/api/v1/books/1") { [200, {}, api_payload] }

        expected_attrs = {"pages" => 77}
        expect(Mli::Book).to receive(:update).with("1", expected_attrs).and_call_original

        expected_output = api_payload.to_json + "\n"

        expect do
          argument_vector = [
            "book",
            "update",
            "1",
            "--pages",
            "77"
          ]

          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end
  end

  describe "view" do
    context "when record not found" do
      it "prints not found error" do
        api_payload = {"error" => "Couldn't find Book with 'id'=1"}
        faraday_stubs.get("/api/v1/books/invalid") { [404, {}, api_payload] }
        expect(Mli::Book).to receive(:view).with("invalid").and_call_original
        expected_output = api_payload.to_json + "\n"

        expect do
          argument_vector = [
            "book",
            "view",
            "invalid"
          ]

          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end

    context "when record is found" do
      it "prints data" do
        api_payload = {
          "created_at" => "2025-01-01T12:00:00.000Z",
          "finished_on" => "2025-01-01",
          "format" => "print",
          "id" => 1,
          "isbn" => "123-456-789",
          "pages" => 77,
          "title" => "best book",
          "updated_at" => "2025-01-01T13:00:00.000Z"
        }

        faraday_stubs.get("/api/v1/books/1") { [200, {}, api_payload] }
        expect(Mli::Book).to receive(:view).with("1").and_call_original
        expected_output = api_payload.to_json + "\n"

        expect do
          argument_vector = [
            "book",
            "view",
            "1"
          ]

          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end
  end
end
