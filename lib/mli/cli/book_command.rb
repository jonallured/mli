module Mli
  module Cli
    class BookCommand < BaseCommand
      ATTR_NAMES = %i[finished_on format isbn pages title]

      desc "create", "Create Book resource"
      long_desc docs_for(:book, :create), wrap: false
      option :finished_on, type: :string, required: true, desc: "YYYY-MM-DD or today"
      option :format, type: :string, required: true, enum: %w[audio kindle print]
      option :isbn, type: :string, required: true, desc: "Used to populate pages/title"
      option :pages, type: :numeric, required: false
      option :title, type: :string, required: false
      def create
        attrs = options.slice(*ATTR_NAMES)
        data = Book.create(attrs)
        say formatted(data)
      end

      desc "delete ID", "Delete Book resource with ID"
      long_desc docs_for(:book, :delete), wrap: false
      def delete(id)
        data = Book.delete(id)
        say formatted(data)
      end

      desc "list", "List Book resources"
      long_desc docs_for(:book, :list), wrap: false
      option :page, type: :numeric, default: 1, required: false
      def list
        page = options[:page]
        data = Book.list(page)
        say formatted(data)
      end

      desc "update ID", "Update Book resource with ID"
      long_desc docs_for(:book, :update), wrap: false
      option :finished_on, type: :string, required: false, desc: "YYYY-MM-DD or today"
      option :format, type: :string, required: false, enum: %w[audio kindle print]
      option :isbn, type: :string, required: false, desc: "Used to populate pages/title"
      option :pages, type: :numeric, required: false
      option :title, type: :string, required: false
      def update(id)
        attrs = options.slice(*ATTR_NAMES)
        data = Book.update(id, attrs)
        say formatted(data)
      end

      desc "view ID", "View Book resource with ID"
      long_desc docs_for(:book, :view), wrap: false
      def view(id)
        data = Book.view(id)
        say formatted(data)
      end
    end
  end
end
