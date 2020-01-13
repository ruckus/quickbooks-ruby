describe "Quickbooks::Service::VendorChange" do
  let(:service) { construct_service :vendor_change }

  it "can query for vendors" do
    xml = fixture("vendor_changes.xml")
    model = Quickbooks::Model::VendorChange

    stub_http_request(:get, service.url_for_query, ["200", "OK"], xml)
    vendors = service.query
    expect(vendors.entries.count).to eq 1

    first_vendor = vendors.entries.first
    expect(first_vendor.status).to eq 'Deleted'
    expect(first_vendor.id).to eq "39"

    expect(first_vendor.meta_data).to_not be_nil
    expect(first_vendor.meta_data.last_updated_time).to eq DateTime.parse("2014-12-08T19:36:24-08:00")
  end

  describe "#url_for_query" do
    subject { service.url_for_query }
    it { is_expected.to eq "#{service.url_for_base}/cdc?entities=Vendor" }
  end

end
