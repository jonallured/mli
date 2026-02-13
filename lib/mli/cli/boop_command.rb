module Mli
  module Cli
    class BoopCommand < BaseCommand
      ATTR_NAMES = %i[dismissed_at display_type number]

      desc "create", "Create Boop resource"
      long_desc docs_for(:boop, :create), wrap: false
      option :dismissed_at, type: :string, required: false, desc: "YYYY-MM-DDTHH:MM:SS or now"
      option :display_type, type: :string, required: true, enum: %w[beer heart monster robot skull smile]
      option :number, type: :numeric, required: false
      def create
        attrs = options.slice(*ATTR_NAMES)
        data = Boop.create(attrs)
        say formatted(data)
      end

      desc "delete ID", "Delete Boop resource with ID"
      long_desc docs_for(:boop, :delete), wrap: false
      def delete(id)
        data = Boop.delete(id)
        say formatted(data)
      end

      desc "list", "List Boop resources"
      long_desc docs_for(:boop, :list), wrap: false
      option :page, type: :numeric, default: 1, required: false
      def list
        page = options[:page]
        data = Boop.list(page)
        say formatted(data)
      end

      desc "update ID", "Update Boop resource with ID"
      long_desc docs_for(:boop, :update), wrap: false
      option :dismissed_at, type: :string, required: false, desc: "YYYY-MM-DDTHH:MM:SS or now"
      option :display_type, type: :string, required: false, enum: %w[beer heart monster robot skull smile]
      option :number, type: :numeric, required: false
      def update(id)
        attrs = options.slice(*ATTR_NAMES)
        data = Boop.update(id, attrs)
        say formatted(data)
      end

      desc "view ID", "View Boop resource with ID"
      long_desc docs_for(:boop, :view), wrap: false
      def view(id)
        data = Boop.view(id)
        say formatted(data)
      end
    end
  end
end
