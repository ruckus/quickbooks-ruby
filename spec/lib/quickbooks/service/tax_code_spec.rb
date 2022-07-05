describe "Quickbooks::Service::TaxCode" do
  before(:all) { construct_service :tax_code }

  it "can query tax codes" do
    stub_http_request(:get,
                 @service.url_for_query,
                 ["200", "OK"],
                 fixture("tax_codes.xml"))

    tax_codes = @service.query

    expect(tax_codes.entries.count).to eq(11)
    expect(tax_codes.entries.first.name).to eq("TAX")
  end
end
