module Mli
  module Cli
    class WarmFuzzyCommand < BaseCommand
      ATTR_NAMES = %i[author body received_at screenshot_path title]

      desc "create", "Create WarmFuzzy resource"
      long_desc docs_for(:warm_fuzzy, :create), wrap: false
      option :author, type: :string, required: true
      option :received_at, type: :string, required: true, desc: "YYYY-MM-DDTHH:MM:SS or now"
      option :title, type: :string, required: true
      option :body, type: :string, required: false
      option :screenshot_path, type: :string, required: false
      def create
        attrs = options.slice(*ATTR_NAMES)
        data = WarmFuzzy.create(attrs)
        say formatted(data)
      end

      desc "delete ID", "Delete WarmFuzzy resource with ID"
      long_desc docs_for(:warm_fuzzy, :delete), wrap: false
      def delete(id)
        data = WarmFuzzy.delete(id)
        say formatted(data)
      end

      desc "list", "List WarmFuzzy resources"
      long_desc docs_for(:warm_fuzzy, :list), wrap: false
      option :page, type: :numeric, default: 1, required: false
      def list
        page = options[:page]
        data = WarmFuzzy.list(page)
        say formatted(data)
      end

      desc "update ID", "Update WarmFuzzy resource with ID"
      long_desc docs_for(:warm_fuzzy, :update), wrap: false
      option :author, type: :string, required: false
      option :received_at, type: :string, required: false, desc: "YYYY-MM-DDTHH:MM:SS or now"
      option :title, type: :string, required: false
      option :body, type: :string, required: false
      option :screenshot_path, type: :string, required: false
      def update(id)
        attrs = options.slice(*ATTR_NAMES)
        data = WarmFuzzy.update(id, attrs)
        say formatted(data)
      end

      desc "view ID", "View WarmFuzzy resource with ID"
      long_desc docs_for(:warm_fuzzy, :view), wrap: false
      def view(id)
        data = WarmFuzzy.view(id)
        say formatted(data)
      end
    end
  end
end
