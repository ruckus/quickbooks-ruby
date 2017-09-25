module Quickbooks
  module Service
    module Responses

      class OAuth1HttpResponse < OAuthHttpResponse

        attr_accessor :real_response

        # net/http response
        def initialize(response)
          @real_response = response
        end

        def version
          1
        end

        def code
          @real_response.code.to_i
        end

        def plain_body
          @real_response.plain_body
        end

      end

    end
  end
end
