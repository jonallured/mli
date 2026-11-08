module Mli
  class BaseResource
    def self.page_from(response)
      {
        next_page: response.headers["X-Next-Page"]&.to_i,
        records: response.body,
        total_count: response.headers["X-Total-Count"]&.to_i
      }
    end
  end
end
