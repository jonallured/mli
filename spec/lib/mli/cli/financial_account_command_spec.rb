RSpec.describe Mli::Cli::FinancialAccountCommand do
  describe "list" do
    let(:actual_params) { {} }
    let(:api_status) { 200 }
    let(:argument_vector) { %w[financial_account list] }

    before do
      faraday_stubs.get("/api/v1/financial_accounts") do |env|
        actual_params.merge!(env.params)
        [api_status, api_headers, api_payload]
      end
    end

    context "with no records" do
      let(:api_headers) { {"X-Total-Count" => "0"} }
      let(:api_payload) { [] }

      it "sends no params and prints empty records" do
        expected_output = <<~JSON
          {"next_page":null,"records":[],"total_count":0}
        JSON

        expected_params = {}

        expect do
          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout

        expect(actual_params).to eq expected_params
      end
    end

    context "with no records for a given page" do
      let(:api_headers) { {"X-Total-Count" => "3"} }
      let(:api_payload) { [] }
      let(:argument_vector) { %w[financial_account list --page 7] }

      it "requests that page and prints empty records" do
        expected_output = <<~JSON
          {"next_page":null,"records":[],"total_count":3}
        JSON

        expected_params = {"page" => "7"}

        expect do
          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout

        expect(actual_params).to eq expected_params
      end
    end

    context "with a few records on the last page" do
      let(:api_headers) { {"X-Total-Count" => "2"} }

      let(:api_payload) do
        [
          {
            "category" => "checking",
            "created_at" => "2002-02-02T02:22:22.222Z",
            "id" => 2,
            "name" => "second account",
            "updated_at" => "2002-02-02T02:22:22.222Z"
          },
          {
            "category" => "savings",
            "created_at" => "2001-01-01T01:11:11.111Z",
            "id" => 1,
            "name" => "first account",
            "updated_at" => "2001-01-01T01:11:11.111Z"
          }
        ]
      end

      it "prints those records with a null next_page" do
        expected_output = <<~JSON
          {"next_page":null,"records":#{api_payload.to_json},"total_count":2}
        JSON

        expect do
          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end

    context "with more records on the next page" do
      let(:api_headers) { {"X-Next-Page" => "2", "X-Total-Count" => "3"} }

      let(:api_payload) do
        [
          {
            "category" => "checking",
            "created_at" => "2003-03-03T03:33:33.333Z",
            "id" => 3,
            "name" => "third account",
            "updated_at" => "2003-03-03T03:33:33.333Z"
          }
        ]
      end

      it "prints those records with next_page as an integer" do
        expected_output = <<~JSON
          {"next_page":2,"records":#{api_payload.to_json},"total_count":3}
        JSON

        expect do
          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end

    context "with all options" do
      let(:api_headers) { {"X-Total-Count" => "0"} }
      let(:api_payload) { [] }

      let(:argument_vector) do
        %w[financial_account list --category good_debt --page 2 --per-page 25 --sort=-name,category]
      end

      it "sends those options" do
        expected_output = <<~JSON
          {"next_page":null,"records":[],"total_count":0}
        JSON

        expected_params = {
          "category" => "good_debt",
          "page" => "2",
          "per_page" => "25",
          "sort" => "-name,category"
        }

        expect do
          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout

        expect(actual_params).to eq expected_params
      end
    end

    context "with an invalid option value" do
      let(:api_headers) { {} }
      let(:api_payload) { {"error" => "category must be one of: checking, savings"} }
      let(:api_status) { 400 }
      let(:argument_vector) { %w[financial_account list --category nope] }

      it "prints the API error" do
        expected_output = <<~JSON
          #{api_payload.to_json}
        JSON

        expect do
          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end
  end

  describe "view" do
    let(:argument_vector) { %w[financial_account view 1] }

    before do
      faraday_stubs.get("/api/v1/financial_accounts/1") { [api_status, {}, api_payload] }
    end

    context "without required argument" do
      let(:argument_vector) { %w[financial_account view] }

      it "exits and prints error message" do
        expected_output = <<~ERR
          ERROR: "mli financial_account view" was called with no arguments
          Usage: "mli financial_account view ID"
        ERR

        expect do
          expect do
            Mli::Cli::RootCommand.start(argument_vector)
          end.to raise_error(SystemExit)
        end.to output(expected_output).to_stderr
      end
    end

    context "when record not found" do
      let(:api_payload) { {"error" => "Couldn't find FinancialAccount with 'id'=1"} }
      let(:api_status) { 404 }

      it "prints not found error" do
        expected_output = <<~JSON
          #{api_payload.to_json}
        JSON

        expect do
          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end

    context "when record is found" do
      let(:api_payload) do
        {
          "category" => "checking",
          "created_at" => "2025-01-01T12:00:00.000Z",
          "id" => 1,
          "name" => "best account",
          "updated_at" => "2025-01-01T13:00:00.000Z"
        }
      end

      let(:api_status) { 200 }

      it "prints the record" do
        expected_output = <<~JSON
          #{api_payload.to_json}
        JSON

        expect do
          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout
      end
    end
  end
end
