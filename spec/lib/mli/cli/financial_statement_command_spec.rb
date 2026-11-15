RSpec.describe Mli::Cli::FinancialStatementCommand do
  let(:statement_payload) do
    {
      "created_at" => "2024-07-02T00:00:00.000Z",
      "ending_amount_cents" => 7000,
      "financial_account_id" => 1,
      "id" => 9,
      "net_amount_cents" => -3000,
      "period_start_on" => "2024-06-01",
      "starting_amount_cents" => 10000,
      "updated_at" => "2024-07-02T00:00:00.000Z"
    }
  end

  describe "create" do
    let(:actual_body) { {} }

    before do
      faraday_stubs.post("/api/v1/financial_statements") do |env|
        actual_body.merge!(JSON.parse(env.body))
        [api_status, {}, api_payload]
      end
    end

    context "without required options" do
      let(:api_status) { 201 }
      let(:api_payload) { statement_payload }

      it "exits and prints error message" do
        expected_output = "No value provided for required options '--ending-amount-cents', '--financial-account-id', '--period-start-on', '--starting-amount-cents'\n"

        expect do
          expect do
            Mli::Cli::RootCommand.start(%w[financial_statement create])
          end.to raise_error(SystemExit)
        end.to output(expected_output).to_stderr
      end
    end

    context "with required options" do
      let(:api_status) { 201 }
      let(:api_payload) { statement_payload }

      let(:argument_vector) do
        %w[financial_statement create --financial-account-id 1 --period-start-on 2024-06-01 --starting-amount-cents 10000 --ending-amount-cents 7000]
      end

      it "nests the attrs under financial_statement and prints the created statement" do
        expected_body = {
          "financial_statement" => {
            "ending_amount_cents" => 7000,
            "financial_account_id" => 1,
            "period_start_on" => "2024-06-01",
            "starting_amount_cents" => 10000
          }
        }

        expect do
          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(statement_payload.to_json + "\n").to_stdout

        expect(actual_body).to eq expected_body
      end
    end

    context "with a month the account already has" do
      let(:api_status) { 422 }
      let(:api_payload) { {"error" => "Validation failed: Period start on has already been taken"} }

      let(:argument_vector) do
        %w[financial_statement create --financial-account-id 1 --period-start-on 2024-06-01 --starting-amount-cents 10000 --ending-amount-cents 7000]
      end

      it "prints the API error" do
        expect do
          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(api_payload.to_json + "\n").to_stdout
      end
    end
  end

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

  describe "update" do
    let(:actual_body) { {} }

    before do
      faraday_stubs.patch("/api/v1/financial_statements/9") do |env|
        actual_body.merge!(JSON.parse(env.body))
        [api_status, {}, api_payload]
      end
    end

    context "without required argument" do
      let(:api_status) { 200 }
      let(:api_payload) { statement_payload }

      it "exits and prints error message" do
        expected_output = <<~ERR
          ERROR: "mli financial_statement update" was called with no arguments
          Usage: "mli financial_statement update ID"
        ERR

        expect do
          expect do
            Mli::Cli::RootCommand.start(%w[financial_statement update])
          end.to raise_error(SystemExit)
        end.to output(expected_output).to_stderr
      end
    end

    context "with one option" do
      let(:api_status) { 200 }
      let(:api_payload) { statement_payload.merge("ending_amount_cents" => 8000, "net_amount_cents" => -2000) }

      it "sends only that attr and prints the updated statement" do
        expected_body = {"financial_statement" => {"ending_amount_cents" => 8000}}

        expect do
          Mli::Cli::RootCommand.start(%w[financial_statement update 9 --ending-amount-cents 8000])
        end.to output(api_payload.to_json + "\n").to_stdout

        expect(actual_body).to eq expected_body
      end
    end

    context "with all options" do
      let(:api_status) { 200 }
      let(:api_payload) { statement_payload }

      let(:argument_vector) do
        %w[financial_statement update 9 --period-start-on 2024-06-01 --starting-amount-cents 10000 --ending-amount-cents 7000]
      end

      it "sends all of them" do
        expected_body = {
          "financial_statement" => {
            "ending_amount_cents" => 7000,
            "period_start_on" => "2024-06-01",
            "starting_amount_cents" => 10000
          }
        }

        expect do
          Mli::Cli::RootCommand.start(argument_vector)
        end.to output(api_payload.to_json + "\n").to_stdout

        expect(actual_body).to eq expected_body
      end
    end

    context "with a financial_account_id" do
      let(:api_status) { 200 }
      let(:api_payload) { statement_payload }

      it "isn't an option, since a statement can't change accounts" do
        expect do
          expect do
            Mli::Cli::RootCommand.start(%w[financial_statement update 9 --financial-account-id 2])
          end.to raise_error(SystemExit)
        end.to output(/was called with arguments \["9", "--financial-account-id", "2"\]/).to_stderr
      end
    end

    context "with a period_start_on that isn't the first of a month" do
      let(:api_status) { 422 }
      let(:api_payload) { {"error" => "Validation failed: Period start on must be the first of a month"} }

      it "prints the API error" do
        expect do
          Mli::Cli::RootCommand.start(%w[financial_statement update 9 --period-start-on 2024-06-15])
        end.to output(api_payload.to_json + "\n").to_stdout
      end
    end
  end
end
