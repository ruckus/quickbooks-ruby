module OauthHelpers
  def construct_oauth
    FakeWeb.allow_net_connect = false

    oauth_consumer = OAuth::Consumer.new("app_key", "app_secret", {
        :site               => "https://oauth.intuit.com",
        :request_token_path => "/oauth/v1/get_request_token",
        :authorize_url      => "https://appcenter.intuit.com/Connect/Begin",
        :access_token_path  => "/oauth/v1/get_access_token"
    })

    OAuth::AccessToken.new(oauth_consumer, "token", "secret")
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
