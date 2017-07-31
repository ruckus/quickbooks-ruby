require 'sinatra'
require 'oauth2'
require 'dotenv/load'

client_id = ENV['OAUTH_CLIENT_ID']
client_secret = ENV['OAUTH_CLIENT_SECRET']
oauth_params = {
  :site => "https://appcenter.intuit.com/connect/oauth2",
  :response_type => "code",
  :state => SecureRandom.hex(12),
  :redirect_uri => ENV['OAUTH_REDIRECT_URI'],
  :scope => ["com.intuit.quickbooks.accounting"]
}
oauth_client = OAuth2::Client.new(client_id, client_secret, oauth_params)

get '/' do
  erb :index
end

post '/initiateOauth' do
  url = oauth_client.auth_code.authorize_url(:redirect_uri => ENV['OAUTH_REDIRECT_URI'])
  puts url
  redirect to(url)
end

get '/oauth2callback' do
  erb :oauth2callback
end
