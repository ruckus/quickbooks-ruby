describe "Quickbooks::Service::TaxCode" do
  before(:all) { construct_service :tax_code }

  it "can query tax codes" do
    stub_http_request(:get,
                 @service.url_for_query,
                 ["200", "OK"],
                 fixture("tax_codes.xml"))

    tax_codes = @service.query

    tax_codes.entries.count.should eq(11)
    tax_codes.entries.first.name.should eq("TAX")
  end
end
