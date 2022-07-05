describe "Quickbooks::Service::Preferences" do
  before(:all) do
    construct_service :preferences
  end

  it "can query for preferences" do
    xml = fixture("preferences_query.xml")
    model = Quickbooks::Model::Preferences

    stub_http_request(:get, @service.url_for_query, ["200", "OK"], xml)
    preferences_query = @service.query
    expect(preferences_query.entries.count).to eq(1)

    preferences = preferences_query.entries.first
    expect(preferences.accounting_info.customer_terminology).to eq("Customers")
  end

end
