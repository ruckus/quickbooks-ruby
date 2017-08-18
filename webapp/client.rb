require 'rubygems'
require 'oauth2'
require 'dotenv'

Dotenv.load(File.dirname(__FILE__) + '/.env')

mode = 1

token = ENV['TOKEN']
realm_id = ENV['REALM_ID']
client_id = ENV['OAUTH_CLIENT_ID']
client_secret = ENV['OAUTH_CLIENT_SECRET']
refresh_token = ENV['REFRESH_TOKEN']

oauth_params = {
  :site => "https://appcenter.intuit.com/connect/oauth2",
  :authorize_url => "https://appcenter.intuit.com/connect/oauth2",
  :token_url => "https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer",
  :connection_opts => {
    :proxy => "http://127.0.0.1:8888"
  }
}

client = OAuth2::Client.new(client_id, client_secret, oauth_params)

if mode == 1
  at = OAuth2::AccessToken.new(client, token)
  i = at.get("https://sandbox-quickbooks.api.intuit.com/v3/company/#{realm_id}/customer/1")
  puts i.body
end

if mode == 2
  # get the refresh token from the original access token response, store it, because
  # its needed during the refresh cycle
  at = OAuth2::AccessToken.new(client, token, refresh_token: refresh_token)
  at.refresh!
  puts "refreshed!"
  puts "\n===== Access Token =======\n\n#{at.token}\n\n"
  puts "\n===== Refresh Token =======\n\n#{at.refresh_token}\n\n"
end
