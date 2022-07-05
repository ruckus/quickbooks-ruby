describe "Quickbooks::Service::CustomerChange" do
  let(:service) { construct_service :customer_change }

  it "can query for customers" do
    xml = fixture("customer_changes.xml")
    model = Quickbooks::Model::CustomerChange

    stub_http_request(:get, service.url_for_query, ["200", "OK"], xml)
    customers = service.query
    expect(customers.entries.count).to eq(1)

    first_customer = customers.entries.first
    expect(first_customer.status).to eq('Deleted')
    expect(first_customer.id).to eq("39")

    expect(first_customer.meta_data).not_to be_nil
    expect(first_customer.meta_data.last_updated_time).to eq(DateTime.parse("2014-12-08T19:36:24-08:00"))
  end

  describe "#url_for_query" do
    subject { service.url_for_query }
    it { is_expected.to eq "#{service.url_for_base}/cdc?entities=Customer" }
  end

end
