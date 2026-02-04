module Mli
  module Cli
    class BookCommand < BaseCommand
      desc "create", "Create Book resource"
      long_desc docs_for(:book, :create), wrap: false
      option :finished_on, type: :string, required: true, desc: "YYYY-MM-DD or today"
      option :format, type: :string, required: true, enum: %w[audio kindle print]
      option :isbn, type: :string, required: true, desc: "Used to populate pages/title"
      option :pages, type: :numeric, required: false
      option :title, type: :string, required: false
      def create
        finished_on = (options[:finished_on] == "today") ? Date.today.to_s : options[:finished_on]

        book_attrs = {
          finished_on: finished_on,
          format: options[:format],
          isbn: options[:isbn],
          pages: options[:pages],
          title: options[:title]
        }.compact

        book_data = Book.create(book_attrs)
        say formatted(book_data)
      end

      desc "delete ID", "Delete Book resource with ID"
      long_desc docs_for(:book, :delete), wrap: false
      def delete(book_id)
        book_data = Book.delete(book_id)
        say formatted(book_data)
      end

      desc "list", "List Book resources"
      long_desc docs_for(:book, :list), wrap: false
      option :page, type: :numeric, default: 1, required: false
      def list
        page = options[:page]
        books_data = Book.list(page)
        say formatted(books_data)
      end

      desc "update ID", "Update Book resource with ID"
      long_desc docs_for(:book, :update), wrap: false
      option :finished_on, type: :string, required: false, desc: "YYYY-MM-DD or today"
      option :format, type: :string, required: false, enum: %w[audio kindle print]
      option :isbn, type: :string, required: false, desc: "Used to populate pages/title"
      option :pages, type: :numeric, required: false
      option :title, type: :string, required: false
      def update(book_id)
        finished_on = (options[:finished_on] == "today") ? Date.today.to_s : options[:finished_on]

        book_attrs = {
          finished_on: finished_on,
          format: options[:format],
          isbn: options[:isbn],
          pages: options[:pages],
          title: options[:title]
        }.compact

        book_data = Book.update(book_id, book_attrs)
        say formatted(book_data)
      end

      desc "view ID", "View Book resource with ID"
      long_desc docs_for(:book, :view), wrap: false
      def view(book_id)
        book_data = Book.view(book_id)
        say formatted(book_data)
      end
    end
  end
end
