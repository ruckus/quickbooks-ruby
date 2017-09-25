describe "Quickbooks::Service::TaxRate" do
  before(:all) { construct_service :tax_rate }

  it "can query tax rates" do
    stub_http_request(:get,
                 @service.url_for_query,
                 ["200", "OK"],
                 fixture("tax_rates.xml"))

    tax_rates = @service.query

    tax_rates.entries.count.should eq(1)
    tax_rates.entries.first.name.should eq("Mountain View")
  end
end
