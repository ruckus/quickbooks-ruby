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
        connection = Faraday.new(headers: { 'Content-Type' => 'application/json' }) do |f|
          f.adapter(::Quickbooks.http_adapter)

          if Gem.loaded_specs['faraday'].version >= Gem::Version.create('2.0')
            f.request(:authorization, :basic, oauth.client.id, oauth.client.secret)
          else
            f.basic_auth(oauth.client.id, oauth.client.secret)
          end
        end

        url = "#{DISCONNECT_URL}?minorversion=#{Quickbooks.minorversion}"
        response = connection.post(url) do |request|
          request.body = JSON.generate({ token: oauth.refresh_token || oauth.token })
        end

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
