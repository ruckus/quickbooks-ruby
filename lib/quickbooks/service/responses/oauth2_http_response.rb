module Quickbooks
  module Service
    module Responses

      class OAuth2HttpResponse
        include Quickbooks::Service::Responses::Methods

        attr_accessor :real_response

        # response : Faraday response
        def initialize(response)
          @real_response = response
        end

        def version
          2
        end

        def body
          @real_response.body
        end

        def plain_body
          body
        end

        def code
          @real_response.status.to_i
        end

        def headers
          if @real_response.respond_to?(:headers)
            @real_response.headers
          else
            nil
          end
        end

      end

    end
  end
end
