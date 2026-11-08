module Mli
  class FinancialTransaction < BaseResource
    def self.list(params)
      endpoint = "/api/v1/financial_transactions"
      response = Mli.connection.get(endpoint, params)
      return response.body unless response.success?

      page_from(response)
    end
  end
end
