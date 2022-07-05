describe Quickbooks::Model::AccessTokenResponse do
  it "can parse a successful response" do
    xml = fixture("access_token_200.xml")
    response = Quickbooks::Model::AccessTokenResponse.from_xml(xml)
    expect(response.error?).to be false
    expect(response.error_message).to eq ""
    expect(response.token.length).to be > 0
    expect(response.secret.length).to be > 0
  end

  it "can parse a unsuccessful response" do
    xml = fixture("access_token_270.xml")
    response = Quickbooks::Model::AccessTokenResponse.from_xml(xml)
    expect(response.error?).to be true
  end
end
