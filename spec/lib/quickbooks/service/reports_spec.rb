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

  # it 'can grab xml tabular data' do 
  #   xml = fixture("reports.xml")
  #   model = Quickbooks::Model::Reports

  #   stub_request(:get, @service.url_for_query, ["200", "OK"], xml)
  # end

  # it 'can query between different dates' do 
  #   xml = fixture("reports.xml")
  #   model = Quickbooks::Model::Reports

  #   stub_request(:get, @service.url_for_query, ["200", "OK"], xml)
  # end

  # it 'can query balancesheets' do 
  #   xml = fixture("reports.xml")
  #   model = Quickbooks::Model::Reports

  #   stub_request(:get, @service.url_for_query, ["200", "OK"], xml)
  # end

  # it 'can query cashflow' do 
  #   xml = fixture("reports.xml")
  #   model = Quickbooks::Model::Reports

  #   stub_request(:get, @service.url_for_query, ["200", "OK"], xml)
  # end

  # it 'can query cashflow for different date ranges' do 
  #   xml = fixture("reports.xml")
  #   model = Quickbooks::Model::Reports

  #   stub_request(:get, @service.url_for_query, ["200", "OK"], xml)
  # end

  # it 'can query profit and loss' do 
  #   xml = fixture("reports.xml")
  #   model = Quickbooks::Model::Reports

  #   stub_request(:get, @service.url_for_query, ["200", "OK"], xml)
  # end

  # it 'can query profit and loss over different date ranges' do 
  #   xml = fixture("reports.xml")
  #   model = Quickbooks::Model::Reports

  #   stub_request(:get, @service.url_for_query, ["200", "OK"], xml)
  # end
end