require 'sinatra'
require 'oauth2'
require 'dotenv'
require 'cgi'

Dotenv.load(File.dirname(__FILE__) + '/.env')

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
oauth_client = OAuth2::Client.new(client_id, client_secret, oauth_params)

get '/' do
  @grant_url = oauth_client.auth_code.authorize_url(:redirect_uri => ENV['OAUTH_REDIRECT_URI'],
    :response_type => "code", :state => SecureRandom.hex(12), :scope => "com.intuit.quickbooks.accounting")
  erb :index
end

get '/oauth2callback' do
  @data = {}
  if params[:state]
    if resp = oauth_client.auth_code.get_token(params[:code], :redirect_uri => ENV['OAUTH_REDIRECT_URI'])
      @data[:token] = resp.token
      @data[:refresh_token] = resp.refresh_token
      @data[:realmId] = params[:realmId]

      # construct a request to fetch some data from the API
      at = OAuth2::AccessToken.new(oauth_client, @data[:token])
      resp1 = at.get("https://sandbox-quickbooks.api.intuit.com/v3/company/#{@data[:realmId]}/customer/1")
      @single_xml = resp1.body

      query = CGI.escape("Select * From Customer")
      resp2 = at.get("https://sandbox-quickbooks.api.intuit.com/v3/company/#{@data[:realmId]}/query?query=#{query}")
      @query_xml = resp2.body


    end
  end

  erb :oauth2callback
end
