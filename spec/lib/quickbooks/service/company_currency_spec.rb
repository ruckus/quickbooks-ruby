describe "Quickbooks::Service::CompanyCurrency" do
  before(:all) do
    construct_service :company_currency
  end

  it "can query for company currency" do
    xml = fixture("company_currency_query.xml")
    stub_request(:get, @service.url_for_query, ["200", "OK"], xml)
    company_currency_query = @service.query
    company_currency_query.entries.count.should == 1

    company_currency = company_currency_query.entries.first
    company_currency.name.should == 'Euro'
  end
end
