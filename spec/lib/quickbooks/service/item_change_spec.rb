describe "Quickbooks::Service::ItemChange" do
  let(:service) { construct_service :item_change }

  it "can query for items" do
    xml = fixture("item_changes.xml")
    model = Quickbooks::Model::ItemChange

    stub_http_request(:get, service.url_for_query, ["200", "OK"], xml)
    items = service.query
    expect(items.entries.count).to eq(1)

    first_item = items.entries.first
    expect(first_item.status).to eq('Deleted')
    expect(first_item.id).to eq("39")

    expect(first_item.meta_data).not_to be_nil
    expect(first_item.meta_data.last_updated_time).to eq(DateTime.parse("2014-12-08T19:36:24-08:00"))
  end

  describe "#url_for_query" do
    subject { service.url_for_query }
    it { is_expected.to eq "#{service.url_for_base}/cdc?entities=Item" }
  end

end
