module Quickbooks
  module Service
    class AccessToken < BaseService

      RENEW_URL = "https://appcenter.intuit.com/api/v1/connection/reconnect"
      DISCONNECT_URL = "https://appcenter.intuit.com/api/v1/connection/disconnect"

      # https://developer.intuit.com/docs/0025_quickbooksapi/0053_auth_auth/oauth_management_api#Reconnect
      def renew
        result = nil
        response = do_http_get(RENEW_URL)
        if response
          code = response.code.to_i
          if code == 200
            result = Quickbooks::Model::AccessTokenResponse.from_xml(response.plain_body)
          end
        end

        result
      end

      # https://developer.intuit.com/docs/0025_quickbooksapi/0053_auth_auth/oauth_management_api#Disconnect
      def disconnect
        result = nil
        response = do_http_get(DISCONNECT_URL)
        if response
          code = response.code.to_i
          if code == 200
            result = Quickbooks::Model::AccessTokenResponse.from_xml(response.plain_body)
          end
        end

        result
      end

    end
  end
end
