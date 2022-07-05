describe "Quickbooks::Service::CustomerType" do
  before(:all) do
    construct_service :customer_type
  end

  it "can query for customer types" do
    xml = fixture("customer_types.xml")
    model = Quickbooks::Model::CustomerType
    stub_http_request(:get, @service.url_for_query, ["200", "OK"], xml)
    customer_types = @service.query
    expect(customer_types.entries.count).to eq(4)
    customer_type1 = customer_types.entries[0]
    expect(customer_type1.name).to eq('Retail')
    customer_type2 = customer_types.entries[1]
    expect(customer_type2.name).to eq('Drop Ship')
    customer_type3 = customer_types.entries[2]
    expect(customer_type3.name).to eq('Distributor')
    customer_type4 = customer_types.entries[3]
    expect(customer_type4.name).to eq('Wholesale')
  end

  it "can fetch a customer type by ID" do
    xml = fixture("fetch_customer_type_by_id.xml")
    model = Quickbooks::Model::CustomerType
    stub_http_request(:get, "#{@service.url_for_resource(model::REST_RESOURCE)}/2", ["200", "OK"], xml)
    customer_type = @service.fetch_by_id(2)
    expect(customer_type.name).to eq('Drop Ship')
  end

  it "cannot create a customer type" do
    customer_type = Quickbooks::Model::CustomerType.new
    customer_type.name = 'New Type'
    expect{ @service.create(customer_type) }.to raise_error(Quickbooks::UnsupportedOperation, "Creating/updating CustomerType is not supported by Intuit")
  end

  it "cannot update a customer type" do
    customer_type = Quickbooks::Model::CustomerType.new
    customer_type.name = 'New Type'
    customer_type.id = 1
    customer_type.sync_token = 1
    expect{ @service.create(customer_type) }.to raise_error(Quickbooks::UnsupportedOperation, "Creating/updating CustomerType is not supported by Intuit")
  end

  it "cannot delete a customer type" do
    customer_type = Quickbooks::Model::CustomerType.new
    customer_type.name = 'New Type'
    customer_type.id = 1
    customer_type.sync_token = 1
    expect{ @service.delete(customer_type) }.to raise_error(Quickbooks::UnsupportedOperation, "Deleting CustomerType is not supported by Intuit")
  end

end
