module Mli
  class FinancialAccount < BaseResource
    def self.create(attrs)
      endpoint = "/api/v1/financial_accounts"
      financial_account_params = Mli::ParamBuilder.from(attrs)
      params = {financial_account: financial_account_params}
      response = Mli.connection.post(endpoint, params)
      response.body
    end

    def self.list(params)
      endpoint = "/api/v1/financial_accounts"
      response = Mli.connection.get(endpoint, params)
      return response.body unless response.success?

      page_from(response)
    end

    def self.update(id, attrs)
      endpoint = "/api/v1/financial_accounts/#{id}"
      financial_account_params = Mli::ParamBuilder.from(attrs)
      params = {financial_account: financial_account_params}
      response = Mli.connection.patch(endpoint, params)
      response.body
    end

    def self.view(id)
      endpoint = "/api/v1/financial_accounts/#{id}"
      response = Mli.connection.get(endpoint)
      response.body
    end
  end
end
