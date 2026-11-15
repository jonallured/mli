module Mli
  class FinancialStatement < BaseResource
    def self.create(attrs)
      endpoint = "/api/v1/financial_statements"
      financial_statement_params = Mli::ParamBuilder.from(attrs)
      params = {financial_statement: financial_statement_params}
      response = Mli.connection.post(endpoint, params)
      response.body
    end

    def self.list(params)
      endpoint = "/api/v1/financial_statements"
      response = Mli.connection.get(endpoint, params)
      return response.body unless response.success?

      page_from(response)
    end

    def self.update(id, attrs)
      endpoint = "/api/v1/financial_statements/#{id}"
      financial_statement_params = Mli::ParamBuilder.from(attrs)
      params = {financial_statement: financial_statement_params}
      response = Mli.connection.patch(endpoint, params)
      response.body
    end
  end
end
