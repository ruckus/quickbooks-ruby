module OauthHelpers
  def construct_oauth
    #FakeWeb.allow_net_connect = false

    oauth = nil

    if Quickbooks.oauth_version == 1
      oauth_consumer = OAuth::Consumer.new("app_key", "app_secret", {
          :site               => "https://oauth.intuit.com",
          :request_token_path => "/oauth/v1/get_request_token",
          :authorize_url      => "https://appcenter.intuit.com/Connect/Begin",
          :access_token_path  => "/oauth/v1/get_access_token"
      })

      oauth = OAuth::AccessToken.new(oauth_consumer, "token", "secret")
    end

    if Quickbooks.oauth_version == 2
      oauth_params = {
        :site => "https://appcenter.intuit.com/connect/oauth2",
        :authorize_url => "https://appcenter.intuit.com/connect/oauth2",
        :token_url => "https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer",
        :connection_opts => {}
      }

      oauth_client = OAuth2::Client.new("app_key", "app_secret", oauth_params)
      oauth = OAuth2::AccessToken.new(oauth_client, "token")
    end

    oauth
  end

  def construct_service(model)
    @service = "Quickbooks::Service::#{model.to_s.camelcase}".constantize.new
    @service.access_token = construct_oauth
    @service.company_id = "9991111222"
    @service
  end

  def construct_compact_service(model)
    @service = "Quickbooks::Service::#{model.to_s.camelcase}".constantize.new(access_token: construct_oauth, company_id:"9991111222")
  end
end

RSpec.configure do |config|
  config.include(OauthHelpers)
end
