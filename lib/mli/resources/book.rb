module Mli
  class Book
    def self.create(book_attrs)
      endpoint = "/api/v1/books"
      response = Mli.connection.post(endpoint, book: book_attrs)
      response.body
    end

    def self.delete(book_id)
      endpoint = "/api/v1/books/#{book_id}"
      response = Mli.connection.delete(endpoint)
      return response.body unless response.success?

      {done: :ok}
    end

    def self.list(page)
      endpoint = "/api/v1/books"
      response = Mli.connection.get(endpoint, page: page)
      response.body
    end

    def self.update(book_id, book_attrs)
      endpoint = "/api/v1/books/#{book_id}"
      response = Mli.connection.put(endpoint, book: book_attrs)
      response.body
    end

    def self.view(book_id)
      endpoint = "/api/v1/books/#{book_id}"
      response = Mli.connection.get(endpoint)
      response.body
    end
  end
end
