require 'oauth2'
require 'dotenv/load'

token = ""
realm_id = ""
client_id = ENV['OAUTH_CLIENT_ID']
client_secret = ENV['OAUTH_CLIENT_SECRET']
oauth_params = {
  :site => "https://appcenter.intuit.com/connect/oauth2",
  :authorize_url => "https://appcenter.intuit.com/connect/oauth2",
  :token_url => "https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer",
  :connection_opts => {
    :proxy => "http://127.0.0.1:8888"
  }
}


client = OAuth2::Client.new(client_id, client_secret, oauth_params)

at = OAuth2::AccessToken.new(client, token)
i = at.get("https://sandbox-quickbooks.api.intuit.com/v3/company/#{realm_id}/customer/1")
puts i.body
