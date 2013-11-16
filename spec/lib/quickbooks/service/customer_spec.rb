describe "Quickbooks::Service::Customer" do
  before(:all) do
    construct_service :customer
  end

  it "can query for customers" do
    xml = fixture("customers.xml")
    model = Quickbooks::Model::Customer

    stub_request(:get, @service.url_for_query, ["200", "OK"], xml)
    customers = @service.query
    customers.entries.count.should == 5

    acme = customers.entries.first
    acme.fully_qualified_name.should == 'Acme Enterprises'
  end

  it "can fetch a customer by ID" do
    xml = fixture("fetch_customer_by_id.xml")
    model = Quickbooks::Model::Customer
    stub_request(:get, "#{@service.url_for_resource(model::REST_RESOURCE)}/1", ["200", "OK"], xml)
    customer = @service.fetch_by_id(1)
    customer.fully_qualified_name.should == "Thrifty Meats"
  end

  it "cannot create a customer with an invalid display_name" do
    customer = Quickbooks::Model::Customer.new

    # invalid because the name contains a colon
    customer.display_name = 'Tractor:Trailer'
    lambda do
      @service.create(customer)
    end.should raise_error(InvalidModelException)

    customer.valid?.should == false
    customer.errors.keys.include?(:display_name).should == true
  end

  it "cannot create a customer with an invalid email" do
    customer = Quickbooks::Model::Customer.new
    customer.email_address = "foobar.com"
    lambda do
      @service.create(customer)
    end.should raise_error(InvalidModelException)

    customer.valid?.should == false
    customer.errors.keys.include?(:primary_email_address).should == true
  end

  it "can create a customer" do
    xml = fixture("fetch_customer_by_id.xml")
    model = Quickbooks::Model::Customer

    stub_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml)

    customer = Quickbooks::Model::Customer.new
    customer.company_name = "Thrifty Meats"
    customer.email_address = "info@thriftymeats.com"

    billing_address = Quickbooks::Model::PhysicalAddress.new
    billing_address.line1 = "123 Swift St."
    billing_address.city = "Santa Cruz"
    billing_address.country_sub_division_code = "CA"
    billing_address.postal_code = "95060"
    billing_address.country = "USA"
    customer.billing_address = billing_address

    created_customer = @service.create(customer)
    created_customer.id.should == 1
  end
  #
  # it "can update a customer name" do
  #   customer_xml = windowsFixture("customer.xml")
  #   update_response_xml = windowsFixture("customer_update_success.xml")
  #   model = Quickeebooks::Windows::Model::Customer
  #   customer = model.from_xml(customer_xml)
  #   customer.name.should == "Wine House"
  #
  #   FakeWeb.register_uri(:post, @service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => update_response_xml)
  #
  #   # change the name
  #   customer.name = "Acme Cafe"
  #
  #   update_response = @service.update(customer)
  #   update_response.success?.should == true
  #   update_response.success.party_role_ref.id.value.should == "6762304"
  #   update_response.success.request_name.should == "CustomerMod"
  # end

end
