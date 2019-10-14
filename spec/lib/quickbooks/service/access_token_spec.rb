describe Quickbooks::Service::AccessToken do
  before(:all) do
    construct_service :access_token
  end

  it "can renew a token" do
    xml = fixture("access_token_200.xml")
    stub_http_request(:get, Quickbooks::Service::AccessToken::RENEW_URL, ["200", "OK"], xml, {}, true)

    response = @service.renew
    response.error?.should == false
  end

  it "fails to renew if the token has expired" do
    xml = fixture("access_token_270.xml")

    stub_http_request(:get, Quickbooks::Service::AccessToken::RENEW_URL, ["200", "OK"], xml, {}, true)

    response = @service.renew
    response.error?.should == true
    response.error_code.should    == "270"
    response.error_message.should == "OAuth Token Rejected"
  end

  it "fails to renew if the request is out-of-bounds" do
    xml = fixture("access_token_212.xml")

    stub_http_request(:get, Quickbooks::Service::AccessToken::RENEW_URL, ["200", "OK"], xml, {}, true)

    response = @service.renew
    response.error?.should == true
    response.error_code.should    == "212"
    response.error_message.should == "Token Refresh Window Out of Bounds"
  end

  it "fails to renew if the app is not approved" do
    xml = fixture("access_token_24.xml")

    stub_http_request(:get, Quickbooks::Service::AccessToken::RENEW_URL, ["200", "OK"], xml, {}, true)

    response = @service.renew
    response.error?.should == true
    response.error_code.should    == "24"
    response.error_message.should == "Invalid App Token"
  end

  if ENV["OAUTH2"] == "1"
    it "can successfully disconnect [oauth2]" do
      xml = fixture("disconnect_200.xml")
      stub_http_request(:get, Quickbooks::Service::AccessToken::DISCONNECT_URL_OAUTH2, ["200", "OK"], xml, {}, true)

      response = @service.disconnect
      response.error?.should == false
    end

    it "can fail to disconnect if the auth token is invalid [oauth2]" do
      stub_http_request(:get, Quickbooks::Service::AccessToken::DISCONNECT_URL_OAUTH2, ["400", "Bad Request"], "", {}, true)

      response = @service.disconnect
      response.error?.should == true
      response.error_code.should    == "400"
      response.error_message.should == "Bad Request"
    end
  end

end
