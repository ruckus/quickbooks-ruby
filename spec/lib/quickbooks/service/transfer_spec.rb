describe "Quickbooks::Service::Transfer" do
  before(:all) do
    construct_service :transfer
  end

  it "can query for transfers" do
    xml = fixture("transfers.xml")
    model = Quickbooks::Model::Transfer

    stub_http_request(:get, @service.url_for_query, ["200", "OK"], xml)
    transfers_query = @service.query
    transfers_query.entries.count.should == 1

    transfer = transfers_query.entries.first
    transfer.amount.should == 250.00
  end

end
