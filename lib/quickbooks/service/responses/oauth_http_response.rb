module Quickbooks
  module Service
    module Responses

      # This class just proxies and returns a wrapped response so that callers
      # can invoke a common interface
      class OAuthHttpResponse

        def self.wrap(response)
          return case ::Quickbooks.oauth_version
          when 1
            Quickbooks::Service::Responses::OAuth1HttpResponse.new(response)
          when 2
            Quickbooks::Service::Responses::OAuth2HttpResponse.new(response)
          else
            raise "Dont know how to load a OAuth response of version=#{::Quickbooks.oauth_version}"
          end
        end

      end

    end
  end
end
