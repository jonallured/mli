module Mli
  module Cli
    class FinancialTransactionCommand < BaseCommand
      desc "list", "List FinancialTransaction resources"
      long_desc docs_for(:financial_transaction, :list), wrap: false
      option :financial_account_id, type: :numeric, required: false
      option :posted_on, type: :string, required: false, desc: "YYYY, YYYY-MM or YYYY-MM-DD"
      option :sort, type: :string, required: false, desc: "Comma separated fields from posted_on and amount_cents, --sort=-field for descending"
      index_options
      def list
        params = options.slice(:financial_account_id, :page, :per_page, :posted_on, :sort)
        data = FinancialTransaction.list(params)
        say formatted(data)
      end
    end
  end
end
