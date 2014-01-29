describe "Quickbooks::Service::Payment" do
  before(:all) { construct_service :payment }

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
    model = Quickbooks::Model::Payment
    payment = Quickbooks::Model::Payment.new
    payment.total = 20.0
    payment.sync_token = 0
    payment.id = 8748

    xml = fixture("fetch_payment_by_id.xml")
    stub_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml, true)

    update_response = @service.update(payment, :sparse => true)
    update_response.total = 40.0
  end

  it "can delete a payment" do
    model = Quickbooks::Model::Payment
    payment = Quickbooks::Model::Payment.new
    payment.id = 8748

    xml = fixture("payment_delete_success_response.xml")
    stub_request(:post, "#{@service.url_for_resource(model::REST_RESOURCE)}?operation=delete", ["200", "OK"], xml)

    response = @service.delete(payment)
    response.should == true
  end
end
