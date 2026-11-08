module Mli
  module Cli
    class FinancialStatementCommand < BaseCommand
      desc "list", "List FinancialStatement resources"
      long_desc docs_for(:financial_statement, :list), wrap: false
      option :financial_account_id, type: :numeric, required: false
      option :period_start_on, type: :string, required: false, desc: "YYYY, YYYY-MM or YYYY-MM-DD"
      option :sort, type: :string, required: false, desc: "period_start_on, --sort=-period_start_on for descending"
      index_options
      def list
        params = options.slice(:financial_account_id, :page, :per_page, :period_start_on, :sort)
        data = FinancialStatement.list(params)
        say formatted(data)
      end
    end
  end
end
