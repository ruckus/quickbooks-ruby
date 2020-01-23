describe Quickbooks::Service::AccessToken do
  before(:all) do
    construct_service :access_token
  end

  it "can renew a token" do
    xml = fixture("access_token_200.xml")
    stub_http_request(:get, Quickbooks::Service::AccessToken::RENEW_URL, ["200", "OK"], xml, {}, true)

    response = @service.renew
    expect(response.error?).to eq(false)
  end

  it "fails to renew if the token has expired" do
    xml = fixture("access_token_270.xml")

    stub_http_request(:get, Quickbooks::Service::AccessToken::RENEW_URL, ["200", "OK"], xml, {}, true)

    response = @service.renew
    expect(response.error?).to eq(true)
    expect(response.error_code).to    eq("270")
    expect(response.error_message).to eq("OAuth Token Rejected")
  end

  it "fails to renew if the request is out-of-bounds" do
    xml = fixture("access_token_212.xml")

    stub_http_request(:get, Quickbooks::Service::AccessToken::RENEW_URL, ["200", "OK"], xml, {}, true)

    response = @service.renew
    expect(response.error?).to eq(true)
    expect(response.error_code).to    eq("212")
    expect(response.error_message).to eq("Token Refresh Window Out of Bounds")
  end

  it "fails to renew if the app is not approved" do
    xml = fixture("access_token_24.xml")

    stub_http_request(:get, Quickbooks::Service::AccessToken::RENEW_URL, ["200", "OK"], xml, {}, true)

    response = @service.renew
    expect(response.error?).to eq(true)
    expect(response.error_code).to    eq("24")
    expect(response.error_message).to eq("Invalid App Token")
  end

  it "can successfully disconnect [oauth2]" do
    xml = fixture("disconnect_200.xml")
    stub_http_request(:post, Quickbooks::Service::AccessToken::DISCONNECT_URL, ["200", "OK"], xml, {}, true)

    response = @service.disconnect
    expect(response.error?).to eq(false)
  end

  it "can fail to disconnect if the auth token is invalid [oauth2]" do
    stub_http_request(:post, Quickbooks::Service::AccessToken::DISCONNECT_URL, ["400", "Bad Request"], "", {}, true)

    response = @service.disconnect
    expect(response.error?).to eq(true)
    expect(response.error_code).to    eq("400")
    expect(response.error_message).to eq("Bad Request")
  end
end
