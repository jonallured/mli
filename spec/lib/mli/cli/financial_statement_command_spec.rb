RSpec.describe Mli::Cli::FinancialStatementCommand do
  describe "list" do
    let(:actual_params) { {} }
    let(:api_status) { 200 }
    let(:argument_vector) { %w[financial_statement list] }

    before do
      faraday_stubs.get("/api/v1/financial_statements") do |env|
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
      let(:argument_vector) { %w[financial_statement list --page 7] }

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
            "created_at" => "2002-02-02T02:22:22.222Z",
            "ending_amount_cents" => 2500,
            "financial_account_id" => 1,
            "id" => 2,
            "net_amount_cents" => 500,
            "period_start_on" => "2002-02-01",
            "starting_amount_cents" => 2000,
            "updated_at" => "2002-02-02T02:22:22.222Z"
          },
          {
            "created_at" => "2001-01-01T01:11:11.111Z",
            "ending_amount_cents" => 2000,
            "financial_account_id" => 1,
            "id" => 1,
            "net_amount_cents" => 1000,
            "period_start_on" => "2001-01-01",
            "starting_amount_cents" => 1000,
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
            "created_at" => "2003-03-03T03:33:33.333Z",
            "ending_amount_cents" => 3000,
            "financial_account_id" => 1,
            "id" => 3,
            "net_amount_cents" => 500,
            "period_start_on" => "2003-03-01",
            "starting_amount_cents" => 2500,
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
        %w[financial_statement list --financial-account-id 3 --page 2 --per-page 25 --period-start-on 2024-03 --sort=-period_start_on]
      end

      it "sends those options" do
        expected_output = <<~JSON
          {"next_page":null,"records":[],"total_count":0}
        JSON

        expected_params = {
          "financial_account_id" => "3",
          "page" => "2",
          "per_page" => "25",
          "period_start_on" => "2024-03",
          "sort" => "-period_start_on"
        }

        expect do
          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(expected_output).to_stdout

        expect(actual_params).to eq expected_params
      end
    end

    context "with an invalid option value" do
      let(:api_headers) { {} }
      let(:api_payload) { {"error" => "sort must use: period_start_on"} }
      let(:api_status) { 400 }
      let(:argument_vector) { %w[financial_statement list --sort nope] }

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
end
