describe "Quickbooks::Service::Payment" do
  before(:all) { construct_service :payment }

  # do we need this?
  it "can query for payments" do
    xml = fixture("payments.xml")
    model = Quickbooks::Model::Payment

    stub_request(:get, @service.url_for_query, ["200", "OK"], xml)
    payments = @service.query
    payments.entries.count.should eq(1)

    payment = payments.entries.first
    payment.private_note.should eq("H60jzmw0Uq")
  end

  it "can fetch a payment by ID" do
    xml = fixture("payment_by_id.xml")
    model = Quickbooks::Model::Payment
    stub_request(:get, "#{@service.url_for_resource(model::REST_RESOURCE)}/1", ["200", "OK"], xml)
    payment = @service.fetch_by_id(1)
    payment.private_note.should eq("H60jzmw0Uq")
  end

  it "can create a payment" do
    xml = fixture("fetch_payment_by_id.xml")
    model = Quickbooks::Model::Payment

    stub_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml)

    payment = Quickbooks::Model::Payment.new
    payment.should be_valid

    created_payment = @service.create(payment)
    created_payment.id.should == 8748
  end

  it "can sparse update a payment" do
    pending
    model = Quickbooks::Model::Payment
    payment = Quickbooks::Model::Payment.new
    payment.display_name = "Thrifty Meats"
    payment.sync_token = 2
    payment.id = 1

    xml = fixture("fetch_payment_by_id.xml")
    stub_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml, true)

    payment.valid_for_update?.should == true
    update_response = @service.update(payment, :sparse => true)
    update_response.display_name.should == 'Thrifty Meats'
  end

  it "can delete a payment" do
    pending
    model = Quickbooks::Model::Payment
    payment = Quickbooks::Model::Payment.new
    payment.display_name = "Thrifty Meats"
    payment.sync_token = 2
    payment.id = 1

    xml = fixture("deleted_payment.xml")
    stub_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml, true)

    payment.valid_for_deletion?.should == true
    response = @service.delete(payment)
    response.fully_qualified_name.should == 'Thrifty Meats (deleted)'
    response.active?.should == false
  end
end
