describe "Quickbooks::Service::CustomerChange" do
  before(:all) do
    construct_service :customer_change
  end

  it "can query for customers" do
    xml = fixture("customer_changes.xml")
    model = Quickbooks::Model::customerChange

    stub_request(:get, @service.url_for_query, ["200", "OK"], xml)
    customers = @service.query
    customers.entries.count.should == 1

    first_customer = customers.entries.first
    first_customer.status.should == 'Deleted'
    first_customer.id.should == 39

    first_customer.meta_data.should_not be_nil
    first_customer.meta_data.last_updated_time.should == DateTime.parse("2014-12-08T19:36:24-08:00")
  end

end
