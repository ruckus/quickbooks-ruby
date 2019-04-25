module Quickbooks
  module Service
    class AccessToken < BaseService

      RENEW_URL = "https://appcenter.intuit.com/api/v1/connection/reconnect"
      DISCONNECT_URL_OAUTH1 = "https://appcenter.intuit.com/api/v1/connection/disconnect"
      DISCONNECT_URL_OAUTH2 = "https://developer.api.intuit.com/v2/oauth2/tokens/revoke"

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

        if oauth_v1?
          response = do_http_get(DISCONNECT_URL_OAUTH1)
        elsif oauth_v2?
          conn = Faraday.new
          conn.basic_auth oauth.client.id, oauth.client.secret
          raw_response = conn.post(DISCONNECT_URL_OAUTH2, { token: oauth.refresh_token || oauth.token })
          response = Quickbooks::Service::Responses::OAuth2HttpResponse.new(raw_response)
        end

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
