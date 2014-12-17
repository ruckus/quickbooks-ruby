describe "Quickbooks::Service::Reports" do
  before(:all) do
    construct_service :reports
  end

  it "can query for reports", focus: true do
    xml = fixture("reports.xml")
    model = Quickbooks::Model::Reports

    stub_request(:get, @service.url_for_query, ["200", "OK"], xml)
    reports = @service.query

    reports_val = reports.entries.first
    reports_val.currency.should == 'USD'
  end
end