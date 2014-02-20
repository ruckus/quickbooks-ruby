describe Quickbooks::Model::AccessTokenResponse do
  it "can parse a successful response" do
    xml = fixture("access_token_200.xml")
    response = Quickbooks::Model::AccessTokenResponse.from_xml(xml)
    response.error?.should == false
    response.error_message.should == ""
    response.token.length.should > 0
    response.secret.length.should > 0
  end

  it "can parse a unsuccessful response" do
    xml = fixture("access_token_270.xml")
    response = Quickbooks::Model::AccessTokenResponse.from_xml(xml)
    response.error?.should == true
  end
end