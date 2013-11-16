describe "Quickbooks::Service::Invoice" do
  before(:all) do
    construct_service :invoice
  end

  it "can query for invoices" do
    xml = fixture("invoices.xml")
    model = Quickbooks::Model::Invoice

    stub_request(:get, @service.url_for_query, ["200", "OK"], xml)
    invoices = @service.query
    invoices.entries.count.should == 1

    first_invoice = invoices.entries.first
    first_invoice.doc_number.should == '1001'
  end

end