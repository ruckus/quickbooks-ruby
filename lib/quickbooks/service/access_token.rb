module Quickbooks
  module Service
    class AccessToken < BaseService

      RENEW_URL = "https://appcenter.intuit.com/api/v1/connection/reconnect"
      DISCONNECT_URL = "https://developer.api.intuit.com/v2/oauth2/tokens/revoke"

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
        conn = Faraday.new
        conn.basic_auth oauth.client.id, oauth.client.secret
        response = conn.post(DISCONNECT_URL, token: oauth.refresh_token || oauth.token)

        if response.success?
          Quickbooks::Model::AccessTokenResponse.new(error_code: "0")
        else
          Quickbooks::Model::AccessTokenResponse.new(
            error_code: response.status.to_s, error_message: response.reason_phrase
          )
        end
      end
    end
  end
end
