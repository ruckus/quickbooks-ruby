describe "Quickbooks::Service::Customer" do
  before(:all) do
    construct_service :customer
  end

  it "can query for customers" do
    xml = fixture("customers.xml")
    model = Quickbooks::Model::Customer

    stub_http_request(:get, @service.url_for_query, ["200", "OK"], xml)
    customers = @service.query
    customers.entries.count.should == 5

    acme = customers.entries.first
    acme.fully_qualified_name.should == 'Acme Enterprises'
  end

  it "can fetch a customer by ID" do
    xml = fixture("fetch_customer_by_id.xml")
    model = Quickbooks::Model::Customer
    stub_http_request(:get, "#{@service.url_for_base}/customer/1?minorversion=#{Quickbooks::Model::Customer::MINORVERSION}", ["200", "OK"], xml)

    customer = @service.fetch_by_id(1)
    customer.fully_qualified_name.should == "Thrifty Meats"
  end

  it "cannot create a customer with an invalid display_name" do
    customer = Quickbooks::Model::Customer.new

    # invalid because the name contains a colon
    customer.display_name = 'Tractor:Trailer'
    lambda do
      @service.create(customer)
    end.should raise_error(Quickbooks::InvalidModelException)

    customer.valid?.should == false
    customer.valid_for_create?.should == false
    customer.errors.keys.include?(:display_name).should == true
  end

  it "cannot create a customer with an invalid email" do
    customer = Quickbooks::Model::Customer.new
    customer.email_address = "foobar.com"
    lambda do
      @service.create(customer)
    end.should raise_error(Quickbooks::InvalidModelException)

    customer.valid?.should == false
    customer.errors.keys.include?(:primary_email_address).should == true
  end

  it "can create a customer" do
    xml = fixture("fetch_customer_by_id.xml")
    model = Quickbooks::Model::Customer

    stub_http_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml)

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

    customer.valid_for_create?.should == true
    created_customer = @service.create(customer)
    created_customer.id.should == "1"
  end

  it "can sparse update a customer" do
    model = Quickbooks::Model::Customer
    customer = Quickbooks::Model::Customer.new
    customer.display_name = "Thrifty Meats"
    customer.sync_token = 2
    customer.id = 1

    xml = fixture("fetch_customer_by_id.xml")
    stub_http_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml, {}, true)

    customer.valid_for_update?.should == true
    update_response = @service.update(customer, :sparse => true)
    update_response.display_name.should == 'Thrifty Meats'
  end

  it "can delete a customer" do
    model = Quickbooks::Model::Customer
    customer = Quickbooks::Model::Customer.new
    customer.display_name = "Thrifty Meats"
    customer.sync_token = 2
    customer.id = 1

    xml = fixture("deleted_customer.xml")
    stub_http_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml, {}, true)

    customer.valid_for_deletion?.should == true
    response = @service.delete(customer)
    response.fully_qualified_name.should == 'Thrifty Meats (deleted)'
    response.active?.should == false
  end

end
