module Mli
  class FinancialAccount < BaseResource
    def self.list(params)
      endpoint = "/api/v1/financial_accounts"
      response = Mli.connection.get(endpoint, params)
      return response.body unless response.success?

      page_from(response)
    end

    def self.view(id)
      endpoint = "/api/v1/financial_accounts/#{id}"
      response = Mli.connection.get(endpoint)
      response.body
    end
  end
end
