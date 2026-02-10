module Mli
  class Book
    def self.create(attrs)
      endpoint = "/api/v1/books"
      book_params = Mli::ParamBuilder.from(attrs)
      params = {book: book_params}
      response = Mli.connection.post(endpoint, params)
      response.body
    end

    def self.delete(id)
      endpoint = "/api/v1/books/#{id}"
      response = Mli.connection.delete(endpoint)
      return response.body unless response.success?

      {done: :ok}
    end

    def self.list(page)
      endpoint = "/api/v1/books"
      params = {page: page}
      response = Mli.connection.get(endpoint, params)
      response.body
    end

    def self.update(id, attrs)
      endpoint = "/api/v1/books/#{id}"
      book_params = Mli::ParamBuilder.from(attrs)
      params = {book: book_params}
      response = Mli.connection.put(endpoint, params)
      response.body
    end

    def self.view(id)
      endpoint = "/api/v1/books/#{id}"
      response = Mli.connection.get(endpoint)
      response.body
    end
  end
end
