module Mli
  module Cli
    class BooksCommand < BaseCommand
      desc "create ATTRS", "Create Book record with ATTRS"
      long_desc docs_for(:books, :create), wrap: false
      def create(*args)
        book_attrs = attrs_for(args)
        book_data = Books.create(book_attrs)
        say formatted(book_data)
      end

      desc "delete ID", "Delete Book record for ID"
      long_desc docs_for(:books, :delete), wrap: false
      def delete(book_id)
        book_data = Books.delete(book_id)
        say formatted(book_data)
      end

      desc "list [PAGE]", "List Book records by PAGE"
      long_desc docs_for(:books, :list), wrap: false
      def list(page = 1)
        books_data = Books.list(page)
        say formatted(books_data)
      end

      desc "update ID ATTRS", "Update Book record for ID with ATTRS"
      long_desc docs_for(:books, :update), wrap: false
      def update(book_id, *args)
        book_attrs = attrs_for(args)
        book_data = Books.update(book_id, book_attrs)
        say formatted(book_data)
      end

      desc "view ID", "View Book record for ID"
      long_desc docs_for(:books, :view), wrap: false
      def view(book_id)
        book_data = Books.view(book_id)
        say formatted(book_data)
      end
    end
  end
end
