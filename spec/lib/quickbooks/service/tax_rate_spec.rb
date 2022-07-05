describe "Quickbooks::Service::TaxRate" do
  before(:all) { construct_service :tax_rate }

  it "can query tax rates" do
    stub_http_request(:get,
                 @service.url_for_query,
                 ["200", "OK"],
                 fixture("tax_rates.xml"))

    tax_rates = @service.query

    expect(tax_rates.entries.count).to eq(1)
    expect(tax_rates.entries.first.name).to eq("Mountain View")
  end
end
