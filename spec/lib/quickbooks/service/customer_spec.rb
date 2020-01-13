describe "Quickbooks::Service::Customer" do
  before(:all) do
    construct_service :customer
  end

  it "can query for customers" do
    xml = fixture("customers.xml")
    model = Quickbooks::Model::Customer

    stub_http_request(:get, @service.url_for_query, ["200", "OK"], xml)
    customers = @service.query
    expect(customers.entries.count).to eq(5)

    acme = customers.entries.first
    expect(acme.fully_qualified_name).to eq('Acme Enterprises')
  end

  it "can fetch a customer by ID" do
    xml = fixture("fetch_customer_by_id.xml")
    model = Quickbooks::Model::Customer
    stub_http_request(:get, "#{@service.url_for_base}/customer/1?minorversion=#{Quickbooks::Model::Customer::MINORVERSION}", ["200", "OK"], xml)

    customer = @service.fetch_by_id(1)
    expect(customer.fully_qualified_name).to eq("Thrifty Meats")
  end

  it "cannot create a customer with an invalid display_name" do
    customer = Quickbooks::Model::Customer.new

    # invalid because the name contains a colon
    customer.display_name = 'Tractor:Trailer'
    expect do
      @service.create(customer)
    end.to raise_error(Quickbooks::InvalidModelException)

    expect(customer.valid?).to eq(false)
    expect(customer.valid_for_create?).to eq(false)
    expect(customer.errors.keys.include?(:display_name)).to eq(true)
  end

  it "cannot create a customer with an invalid email" do
    customer = Quickbooks::Model::Customer.new
    customer.email_address = "foobar.com"
    expect do
      @service.create(customer)
    end.to raise_error(Quickbooks::InvalidModelException)

    expect(customer.valid?).to eq(false)
    expect(customer.errors.keys.include?(:primary_email_address)).to eq(true)
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

    expect(customer.valid_for_create?).to eq(true)
    created_customer = @service.create(customer)
    expect(created_customer.id).to eq("1")
  end

  it "can sparse update a customer" do
    model = Quickbooks::Model::Customer
    customer = Quickbooks::Model::Customer.new
    customer.display_name = "Thrifty Meats"
    customer.sync_token = 2
    customer.id = 1

    xml = fixture("fetch_customer_by_id.xml")
    stub_http_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml, {}, true)

    expect(customer.valid_for_update?).to eq(true)
    update_response = @service.update(customer, :sparse => true)
    expect(update_response.display_name).to eq('Thrifty Meats')
  end

  it "can delete a customer" do
    model = Quickbooks::Model::Customer
    customer = Quickbooks::Model::Customer.new
    customer.display_name = "Thrifty Meats"
    customer.sync_token = 2
    customer.id = 1

    xml = fixture("deleted_customer.xml")
    stub_http_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml, {}, true)

    expect(customer.valid_for_deletion?).to eq(true)
    response = @service.delete(customer)
    expect(response.fully_qualified_name).to eq('Thrifty Meats (deleted)')
    expect(response.active?).to eq(false)
  end

end
