describe "Quickbooks::Service::TimeActivity" do
  before(:all) do
    construct_service :time_activity
  end

  it "can query for time_activities" do
    xml = fixture("time_activities.xml")
    stub_http_request(:get, @service.url_for_query, ["200", "OK"], xml)
    time_activities = @service.query
    time_activities.entries.count.should == 2
    ta1 = time_activities.entries.first
    ta1.description.should == 'Description 1'
    ta2 = time_activities.entries.last
    ta2.description.should == 'Description 2'
  end

  it "can fetch a time_activity by ID" do
    xml = fixture("fetch_time_activity_by_id.xml")
    model = Quickbooks::Model::TimeActivity
    stub_http_request(:get, "#{@service.url_for_resource(model::REST_RESOURCE)}/1", ["200", "OK"], xml)
    time_activity = @service.fetch_by_id(1)
    time_activity.description.should == "Description 1"
  end

  it "cannot create a time_activity with an invalid name_of" do
    time_activity = Quickbooks::Model::TimeActivity.new
    lambda do
      @service.create(time_activity)
    end.should raise_error(Quickbooks::InvalidModelException)

    time_activity.valid?.should == false
    time_activity.errors.keys.include?(:name_of).should == true
  end

  it "cannot create a time_activity with an empty employee_ref" do
    time_activity = Quickbooks::Model::TimeActivity.new
    time_activity.name_of = "Employee"
    lambda do
      @service.create(time_activity)
    end.should raise_error(Quickbooks::InvalidModelException)

    time_activity.valid?.should == false
    time_activity.errors.keys.include?(:employee_ref).should == true
  end

  it "cannot create a time_activity with an empty vendor_ref" do
    time_activity = Quickbooks::Model::TimeActivity.new
    time_activity.name_of = "Vendor"
    lambda do
      @service.create(time_activity)
    end.should raise_error(Quickbooks::InvalidModelException)

    time_activity.valid?.should == false
    time_activity.errors.keys.include?(:vendor_ref).should == true
  end

  it "can create a time_activity" do
    xml = fixture("fetch_time_activity_by_id.xml")
    model = Quickbooks::Model::TimeActivity

    stub_http_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml)

    employee = Quickbooks::Model::BaseReference.new(66, name: 'John Smith')

    item = Quickbooks::Model::BaseReference.new(49, name: 'General Consulting')

    customer = Quickbooks::Model::BaseReference.new(123, name: 'Test Customer')

    time_activity = Quickbooks::Model::TimeActivity.new
    time_activity.txn_date = Date.today
    time_activity.name_of = "Employee"
    time_activity.employee_ref = employee
    time_activity.customer_ref = customer
    time_activity.item_ref = item
    time_activity.description = "Description 1"
    time_activity.billable_status = "Billable"

    time_activity.hourly_rate = 115
    time_activity.hours = 1
    time_activity.minutes = 30

    time_activity.valid_for_create?.should == true
    created_time_activity = @service.create(time_activity)
    created_time_activity.id.should == "1"
  end

  it "can delete a time_activity" do
    model = Quickbooks::Model::TimeActivity
    time_activity = Quickbooks::Model::TimeActivity.new
    time_activity.sync_token = 2
    time_activity.id = 1

    xml = fixture("deleted_time_activity.xml")
    stub_http_request(:post, "#{@service.url_for_resource(model::REST_RESOURCE)}?operation=delete", ["200", "OK"], xml)

    response = @service.delete(time_activity)
    response.should == true

  end
end
