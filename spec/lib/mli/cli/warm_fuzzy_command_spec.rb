RSpec.describe Mli::Cli::WarmFuzzyCommand do
  describe "create" do
    context "without required options" do
      it "exits and prints error message" do
        expected_output = "No value provided for required options '--author', '--received-at', '--title'\n"

        expect do
          expect do
            argument_vector = [
              "warm_fuzzy",
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
          "author" => "Your Biggest Fan",
          "body" => nil,
          "created_at" => "2026-02-01T00:00:00.000Z",
          "id" => 1,
          "received_at" => "2026-01-01T00:00:00.000Z",
          "screenshot" => nil,
          "title" => "Just Okay",
          "updated_at" => "2026-02-01T00:00:00.000Z"
        }

        faraday_stubs.post("/api/v1/warm_fuzzies") { [201, {}, api_payload] }

        expected_attrs = {
          "author" => "Your Biggest Fan",
          "received_at" => "2026-01-01T00:00:00Z",
          "title" => "Just Okay"
        }

        expect(Mli::WarmFuzzy).to receive(:create).with(expected_attrs).and_call_original

        expected_output = api_payload.to_json + "\n"

        expect do
          argument_vector = [
            "warm_fuzzy",
            "create",
            "--author",
            "Your Biggest Fan",
            "--received-at",
            "2026-01-01T00:00:00Z",
            "--title",
            "Just Okay"
          ]

          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end

    context "with all options" do
      it "sends api call with all options and prints created data" do
        api_payload = {
          "author" => "Your Biggest Fan",
          "body" => "I think you are just okay.",
          "created_at" => "2026-02-01T00:00:00.000Z",
          "id" => 1,
          "received_at" => "2026-01-01T00:00:00.000Z",
          "screenshot" => "something",
          "title" => "Just Okay",
          "updated_at" => "2026-02-01T00:00:00.000Z"
        }

        faraday_stubs.post("/api/v1/warm_fuzzies") { [201, {}, api_payload] }

        expected_attrs = {
          "author" => "Your Biggest Fan",
          "body" => "I think you are just okay.",
          "received_at" => "2026-01-01T00:00:00Z",
          "screenshot_path" => "test.png",
          "title" => "Just Okay"
        }

        expect(Mli::WarmFuzzy).to receive(:create).with(expected_attrs).and_call_original

        expected_output = api_payload.to_json + "\n"

        expect do
          argument_vector = [
            "warm_fuzzy",
            "create",
            "--author",
            "Your Biggest Fan",
            "--received-at",
            "2026-01-01T00:00:00Z",
            "--title",
            "Just Okay",
            "--body",
            "I think you are just okay.",
            "--screenshot_path",
            "test.png"
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
          ERROR: "mli warm_fuzzy delete" was called with no arguments
          Usage: "mli warm_fuzzy delete ID"
        ERR

        expect do
          expect do
            argument_vector = [
              "warm_fuzzy",
              "delete"
            ]

            Mli::Cli::RootCommand.start(argument_vector)
          end.to raise_error(SystemExit)
        end.to output(expected_output).to_stderr
      end
    end

    context "when record not found" do
      it "prints not found error" do
        api_payload = {"error" => "Couldn't find WarmFuzzy with 'id'=invalid"}
        faraday_stubs.delete("/api/v1/warm_fuzzies/invalid") { [404, {}, api_payload] }
        expect(Mli::WarmFuzzy).to receive(:delete).with("invalid").and_call_original
        expected_output = api_payload.to_json + "\n"

        expect do
          argument_vector = [
            "warm_fuzzy",
            "delete",
            "invalid"
          ]

          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end

    context "when record is found" do
      it "prints done" do
        faraday_stubs.delete("/api/v1/warm_fuzzies/1") { [200, {}, ""] }
        expect(Mli::WarmFuzzy).to receive(:delete).with("1").and_call_original
        expected_output = {done: :ok}.to_json + "\n"

        expect do
          argument_vector = [
            "warm_fuzzy",
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
        faraday_stubs.get("/api/v1/warm_fuzzies") { [200, {}, api_payload] }
        expect(Mli::WarmFuzzy).to receive(:list).with(1).and_call_original
        expected_output = api_payload.to_json + "\n"

        expect do
          argument_vector = [
            "warm_fuzzy",
            "list"
          ]

          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end

    context "with no records for a given page" do
      it "requests that page and prints empty array" do
        api_payload = []
        faraday_stubs.get("/api/v1/warm_fuzzies") { [200, {}, api_payload] }
        expect(Mli::WarmFuzzy).to receive(:list).with(7).and_call_original
        expected_output = api_payload.to_json + "\n"

        expect do
          argument_vector = [
            "warm_fuzzy",
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
            "author" => "333",
            "body" => nil,
            "created_at" => "2003-03-03T03:33:33.333Z",
            "id" => 3,
            "received_at" => "2003-03-03T03:33:33.333Z",
            "screenshot" => nil,
            "title" => "333",
            "updated_at" => "2003-03-03T03:33:33.333Z"
          },
          {
            "author" => "222",
            "body" => nil,
            "created_at" => "2002-02-02T02:22:22.222Z",
            "id" => 2,
            "received_at" => "2002-02-02T02:22:22.222Z",
            "screenshot" => nil,
            "title" => "222",
            "updated_at" => "2002-02-02T02:22:22.222Z"
          },
          {
            "author" => "111",
            "body" => nil,
            "created_at" => "2001-01-01T01:11:11.111Z",
            "id" => 1,
            "received_at" => "2001-01-01T01:11:11.111Z",
            "screenshot" => nil,
            "title" => "111",
            "updated_at" => "2001-01-01T01:11:11.111Z"
          }
        ]

        faraday_stubs.get("/api/v1/warm_fuzzies") { [200, {}, api_payload] }
        expect(Mli::WarmFuzzy).to receive(:list).with(1).and_call_original
        expected_output = api_payload.to_json + "\n"

        expect do
          argument_vector = [
            "warm_fuzzy",
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
          ERROR: "mli warm_fuzzy update" was called with no arguments
          Usage: "mli warm_fuzzy update ID"
        ERR

        expect do
          expect do
            argument_vector = [
              "warm_fuzzy",
              "update"
            ]

            Mli::Cli::RootCommand.start(argument_vector)
          end.to raise_error(SystemExit)
        end.to output(expected_output).to_stderr
      end
    end

    context "with no options" do
      it "prints missing error" do
        api_payload = {"error" => "param is missing or the value is empty or invalid: warm_fuzzy"}
        faraday_stubs.put("/api/v1/warm_fuzzies/1") { [400, {}, api_payload] }
        expected_output = api_payload.to_json + "\n"

        expect do
          argument_vector = [
            "warm_fuzzy",
            "update",
            "1"
          ]

          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end

    context "when record not found" do
      it "prints not found error" do
        api_payload = {"error" => "Couldn't find WarmFuzzy with 'id'=1"}
        faraday_stubs.put("/api/v1/warm_fuzzies/1") { [404, {}, api_payload] }
        expected_output = api_payload.to_json + "\n"

        expect do
          argument_vector = [
            "warm_fuzzy",
            "update",
            "1",
            "--body",
            "Is this better?"
          ]

          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end

    context "with an option" do
      it "prints updated data" do
        api_payload = {
          "author" => "Your Biggest Fan",
          "body" => "Is this better?",
          "created_at" => "2026-02-01T00:00:00.000Z",
          "id" => 1,
          "received_at" => "2026-01-01T00:00:00.000Z",
          "screenshot" => "something",
          "title" => "Just Okay",
          "updated_at" => "2026-02-01T00:00:00.000Z"
        }

        faraday_stubs.put("/api/v1/warm_fuzzies/1") { [200, {}, api_payload] }

        expected_attrs = {"body" => "Is this better?"}
        expect(Mli::WarmFuzzy).to receive(:update).with("1", expected_attrs).and_call_original

        expected_output = api_payload.to_json + "\n"

        expect do
          argument_vector = [
            "warm_fuzzy",
            "update",
            "1",
            "--body",
            "Is this better?"
          ]

          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end
  end

  describe "view" do
    context "when record not found" do
      it "prints not found error" do
        api_payload = {"error" => "Couldn't find WarmFuzzy with 'id'=invalid"}
        faraday_stubs.get("/api/v1/warm_fuzzies/invalid") { [404, {}, api_payload] }
        expect(Mli::WarmFuzzy).to receive(:view).with("invalid").and_call_original
        expected_output = api_payload.to_json + "\n"

        expect do
          argument_vector = [
            "warm_fuzzy",
            "view",
            "invalid"
          ]

          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end

    context "when record is found" do
      it "prints warmfuzzy data" do
        api_payload = {
          "author" => "Your Biggest Fan",
          "body" => "I think you are just okay.",
          "created_at" => "2026-02-01T00:00:00.000Z",
          "id" => 1,
          "received_at" => "2026-01-01T00:00:00.000Z",
          "screenshot" => "something",
          "title" => "Just Okay",
          "updated_at" => "2026-02-01T00:00:00.000Z"
        }

        faraday_stubs.get("/api/v1/warm_fuzzies/1") { [200, {}, api_payload] }
        expect(Mli::WarmFuzzy).to receive(:view).with("1").and_call_original
        expected_output = api_payload.to_json + "\n"

        expect do
          argument_vector = [
            "warm_fuzzy",
            "view",
            "1"
          ]

          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end
  end
end
