module Mli
  module Cli
    class FinancialStatementCommand < BaseCommand
      UPDATE_ATTR_NAMES = %i[ending_amount_cents period_start_on starting_amount_cents]
      CREATE_ATTR_NAMES = UPDATE_ATTR_NAMES + %i[financial_account_id]

      desc "create", "Create FinancialStatement resource"
      long_desc docs_for(:financial_statement, :create), wrap: false
      option :ending_amount_cents, type: :numeric, required: true
      option :financial_account_id, type: :numeric, required: true
      option :period_start_on, type: :string, required: true, desc: "YYYY-MM-01"
      option :starting_amount_cents, type: :numeric, required: true
      def create
        attrs = options.slice(*CREATE_ATTR_NAMES)
        data = FinancialStatement.create(attrs)
        say formatted(data)
      end

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

      desc "update ID", "Update FinancialStatement resource with ID"
      long_desc docs_for(:financial_statement, :update), wrap: false
      option :ending_amount_cents, type: :numeric, required: false
      option :period_start_on, type: :string, required: false, desc: "YYYY-MM-01"
      option :starting_amount_cents, type: :numeric, required: false
      def update(id)
        attrs = options.slice(*UPDATE_ATTR_NAMES)
        data = FinancialStatement.update(id, attrs)
        say formatted(data)
      end
    end
  end
end
