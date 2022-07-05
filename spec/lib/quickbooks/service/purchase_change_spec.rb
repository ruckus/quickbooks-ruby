describe "Quickbooks::Service::PurchaseChange" do
  let(:service) { construct_service :purchase_change }

  it "can query for payments" do
    xml = fixture("purchase_changes.xml")
    model = Quickbooks::Model::PurchaseChange
    stub_http_request(:get, service.url_for_query, ["200", "OK"], xml)
    purchases = service.query
    expect(purchases.entries.count).to eq(1)

    purchase = purchases.entries.first
    expect(purchase.status).to eq('Deleted')
    expect(purchase.id).to eq("39")

    expect(purchase.meta_data).not_to be_nil
    expect(purchase.meta_data.last_updated_time).to eq(DateTime.parse("2014-12-08T19:36:24-08:00"))
  end

  describe "#url_for_query" do
    subject { service.url_for_query }
    it { is_expected.to eq "#{service.url_for_base}/cdc?entities=Purchase" }
  end

end
