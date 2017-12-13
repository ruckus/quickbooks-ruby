require 'rubygems'
require 'oauth2'
require 'dotenv'

$:.unshift File.expand_path("../../lib", __FILE__)
require "quickbooks-ruby"

Dotenv.load(File.dirname(__FILE__) + '/.env')

Quickbooks.sandbox_mode = true
Quickbooks.log = true

mode = 4

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
  refreshed = at.refresh!
  puts "refreshed!"
  puts "\n===== Access Token =======\n\n#{refreshed.token}\n\n"
  puts "\n===== Refresh Token =======\n\n#{refreshed.refresh_token}\n\n"
end

if mode == 3
  client = OAuth2::Client.new(client_id, client_secret, oauth_params)
  at = OAuth2::AccessToken.new(client, token, refresh_token: refresh_token)
  service = Quickbooks::Service::Customer.new
  service.access_token = at
  service.realm_id = realm_id

  customer = Quickbooks::Model::Customer.new
  customer.display_name = "Test 123"
  customer.company_name = "Test 123"
  customer.email_address = "test@example.com"
  service.create(customer)
end


if mode == 4
  client = OAuth2::Client.new(client_id, client_secret, oauth_params)
  at = OAuth2::AccessToken.new(client, token, refresh_token: refresh_token)
  service = Quickbooks::Service::Customer.new
  service.access_token = at
  service.realm_id = realm_id
  b = service.query
  #puts b.inspect
end
