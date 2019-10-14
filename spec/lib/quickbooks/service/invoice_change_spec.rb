describe "Quickbooks::Service::InvoiceChange" do
  let(:service) { construct_service :invoice_change }

  it "can query for invoices" do
    xml = fixture("invoice_changes.xml")
    model = Quickbooks::Model::InvoiceChange

    stub_http_request(:get, service.url_for_query, ["200", "OK"], xml)
    invoices = service.query
    invoices.entries.count.should == 1

    first_invoice = invoices.entries.first
    first_invoice.status.should == 'Deleted'
    first_invoice.id.should == "39"

    first_invoice.meta_data.should_not be_nil
    first_invoice.meta_data.last_updated_time.should == DateTime.parse("2014-12-08T19:36:24-08:00")
  end

  describe "#url_for_query" do
    subject { service.url_for_query }
    it { should eq "#{service.url_for_base}/cdc?entities=Invoice" }
  end

end
