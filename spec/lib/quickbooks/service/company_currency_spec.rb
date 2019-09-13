describe "Quickbooks::Service::CompanyCurrency" do
  let(:model) { Quickbooks::Model::CompanyCurrency }

  before(:all) do
    construct_service :company_currency
  end

  it "can query for company currency" do
    xml = fixture("company_currency_query.xml")
    stub_http_request(:get, @service.url_for_query, ["200", "OK"], xml)
    company_currency_query = @service.query
    company_currency_query.entries.count.should == 1

    company_currency = company_currency_query.entries.first
    company_currency.name.should == 'Euro'
  end

  it 'can fetch a company currency by id' do
    xml = fixture('fetch_company_currency_by_id.xml')
    stub_http_request(:get,
      "#{@service.url_for_resource(model::REST_RESOURCE)}/1",
      ["200", "OK"],
      xml
    )
    company_currency = @service.fetch_by_id(1)

    company_currency.id.should == "1"
    company_currency.name.should == 'Euro'
  end

  it 'can create a company currency' do
    xml = fixture('fetch_company_currency_by_id.xml')
    stub_http_request(:post,
      @service.url_for_resource(model::REST_RESOURCE),
      ["200", "OK"],
      xml
    )
    company_currency = model.new(:id => 1, :sync_token => 2, :code => 'EUR')

    company_currency.should be_valid_for_create
    created_company_currency = @service.create(company_currency)
    created_company_currency.id.should == '1'
    created_company_currency.code.should == 'EUR'
  end

  it 'can delete a company currency' do
    xml = fixture('deleted_company_currency.xml')
    company_currency = model.new(:id => 1, :sync_token => 2, :code => 'EUR')
    stub_http_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml, {}, true)

    company_currency.should be_valid_for_deletion
    deleted_company_currency = @service.delete(company_currency)
    deleted_company_currency.should_not be_active
  end
end
