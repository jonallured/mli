module Mli
  module Cli
    class FinancialAccountCommand < BaseCommand
      ATTR_NAMES = %i[category closed_on name]

      desc "create", "Create FinancialAccount resource"
      long_desc docs_for(:financial_account, :create), wrap: false
      option :category, type: :string, required: true
      option :closed_on, type: :string, required: false, desc: "YYYY-MM-DD or today"
      option :name, type: :string, required: true
      def create
        attrs = options.slice(*ATTR_NAMES)
        data = FinancialAccount.create(attrs)
        say formatted(data)
      end

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

      desc "update ID", "Update FinancialAccount resource with ID"
      long_desc docs_for(:financial_account, :update), wrap: false
      option :category, type: :string, required: false
      option :closed_on, type: :string, required: false, desc: "YYYY-MM-DD or today"
      option :name, type: :string, required: false
      def update(id)
        attrs = options.slice(*ATTR_NAMES)
        data = FinancialAccount.update(id, attrs)
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
