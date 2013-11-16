module OauthHelpers
  def construct_oauth
    FakeWeb.allow_net_connect = false
    qb_key = "key"
    qb_secret = "secreet"

    @company_id = "9991111222"
    @oauth_consumer = OAuth::Consumer.new(qb_key, qb_secret, {
        :site               => "https://oauth.intuit.com",
        :request_token_path => "/oauth/v1/get_request_token",
        :authorize_path     => "/oauth/v1/get_access_token",
        :access_token_path  => "/oauth/v1/get_access_token"
    })
    @oauth = OAuth::AccessToken.new(@oauth_consumer, "blah", "blah")
  end

  def construct_service(model)
    construct_oauth

    @service = "Quickbooks::Service::#{model.to_s.camelcase}".constantize.new
    @service.access_token = @oauth
    @service.instance_eval {
      @company_id = "9991111222"
    }
  end

end

RSpec.configure do |config|
  config.include(OauthHelpers)
end
