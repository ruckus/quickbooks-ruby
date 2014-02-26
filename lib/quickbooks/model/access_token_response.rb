module Quickbooks
  module Model
    class AccessTokenResponse < BaseModel
      xml_convention :camelcase
      xml_accessor :error_code, :from => 'ErrorCode'
      xml_accessor :error_message, :from => 'ErrorMessage'
      xml_accessor :token,  :from => 'OAuthToken'
      xml_accessor :secret, :from => 'OAuthTokenSecret'
      xml_accessor :server_time, :from => 'ServerTime', :as => Time

      def error?
        error_code.to_i != 0
      end

    end
  end
end

=begin
<?xml version="1.0"?>
<ReconnectResponse xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="http://platform.intuit.com/api/v1">
  <ErrorMessage/>
  <ErrorCode>0</ErrorCode>
  <ServerTime>2012-01-04T19:21:21.0782072Z</ServerTime>
  <OAuthToken>qye2eIdQ5H5yMyrlJflUWh712xfFXjyNnW1MfbC0rz04TfCP</OAuthToken>
  <OAuthTokenSecret>cyDeUNQTkFzoR0KkDn7viN6uLQxWTobeEUKW7I79</OAuthTokenSecret>
</ReconnectResponse>

=end