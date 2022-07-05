describe "Quickbooks::Service::CompanyInfo" do
  before(:all) do
    construct_service :company_info
  end

  it "can query for company info" do
    xml = fixture("company_info_query.xml")
    model = Quickbooks::Model::CompanyInfo

    stub_http_request(:get, @service.url_for_query, ["200", "OK"], xml)
    company_info_query = @service.query
    expect(company_info_query.entries.count).to eq(1)

    company_info = company_info_query.entries.first
    expect(company_info.company_name).to eq('Acme Corp.')
  end

  it "can fetch company info by ID" do
    xml = fixture("fetch_company_info_by_id.xml")
    model = Quickbooks::Model::CompanyInfo
    stub_http_request(:get, "#{@service.url_for_resource(model::REST_RESOURCE)}/1", ["200", "OK"], xml)
    company_info = @service.fetch_by_id(1)
    expect(company_info.company_name).to eq("Acme Corp.")
  end
end
