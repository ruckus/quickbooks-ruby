module Quickbooks
  module Service
    module Responses

      # This class just proxies and returns a wrapped response so that callers
      # can invoke a common interface
      class OAuthHttpResponse

        def self.wrap(response)
          Quickbooks::Service::Responses::OAuth2HttpResponse.new(response)
        end

      end

    end
  end
end
