module Mli
  module Cli
    class FinancialAccountCommand < BaseCommand
      desc "list", "List FinancialAccount resources"
      long_desc docs_for(:financial_account, :list), wrap: false
      option :category, type: :string, required: false
      option :sort, type: :string, required: false, desc: "Comma separated fields from category and name, --sort=-field for descending"
      index_options
      def list
        params = options.slice(:category, :page, :per_page, :sort)
        data = FinancialAccount.list(params)
        say formatted(data)
      end

      desc "view ID", "View FinancialAccount resource with ID"
      long_desc docs_for(:financial_account, :view), wrap: false
      def view(id)
        data = FinancialAccount.view(id)
        say formatted(data)
      end
    end
  end
end
