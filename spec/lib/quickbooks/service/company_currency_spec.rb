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

  it 'can delete a company_currency' do
    xml = fixture('deleted_company_currency.xml')
    model = Quickbooks::Model::CompanyCurrency
    company_currency = model.new(:id => 1, :sync_token => 2, :code => 'EUR')
    stub_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml, {}, true)

    company_currency.should be_valid_for_deletion
    deleted_company_currency = @service.delete(company_currency)
    deleted_company_currency.should_not be_active
  end
end
