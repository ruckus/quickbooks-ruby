describe "Quickbooks::Service::InvoiceChange" do
  let(:service) { construct_service :invoice_change }

  it "can query for invoices" do
    xml = fixture("invoice_changes.xml")
    model = Quickbooks::Model::InvoiceChange

    stub_http_request(:get, service.url_for_query, ["200", "OK"], xml)
    invoices = service.query
    expect(invoices.entries.count).to eq(1)

    first_invoice = invoices.entries.first
    expect(first_invoice.status).to eq('Deleted')
    expect(first_invoice.id).to eq("39")

    expect(first_invoice.meta_data).not_to be_nil
    expect(first_invoice.meta_data.last_updated_time).to eq(DateTime.parse("2014-12-08T19:36:24-08:00"))
  end

  describe "#url_for_query" do
    subject { service.url_for_query }
    it { is_expected.to eq "#{service.url_for_base}/cdc?entities=Invoice" }
  end

end
