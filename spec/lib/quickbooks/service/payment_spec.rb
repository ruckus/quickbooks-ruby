describe "Quickbooks::Service::Payment" do
  before(:all) { construct_service :payment }

  let(:customer_ref) { Quickbooks::Model::BaseReference.new(42) }
  let(:model) { Quickbooks::Model::Payment }
  let(:payment) { model.new :id => 8748, :customer_ref => customer_ref }
  let(:resource) { model::REST_RESOURCE }

  it "can query for payments" do
    stub_http_request(:get,
                 @service.url_for_query,
                 ["200", "OK"],
                 fixture("payments.xml"))

    payments = @service.query

    payments.entries.count.should == 1
    payment = payments.entries.first
    payment.private_note.should == "H60jzmw0Uq"
  end

  it "can fetch a payment by ID" do
    stub_http_request(:get,
                 "#{@service.url_for_resource(resource)}/1",
                 ["200", "OK"],
                 fixture("payment_by_id.xml"))

    payment = @service.fetch_by_id(1)

    payment.private_note.should == "H60jzmw0Uq"
  end

  it "can create a payment" do
    stub_http_request(:post,
                 @service.url_for_resource(resource),
                 ["200", "OK"],
                 fixture("fetch_payment_by_id.xml"))

    created_payment = @service.create(payment)

    created_payment.id.should == "8748"
  end

  it "can sparse update a payment" do
    payment.total = 20.0
    stub_http_request(:post,
                 @service.url_for_resource(resource),
                 ["200", "OK"],
                 fixture("fetch_payment_by_id.xml"),
                 {},
                 true)

    update_response = @service.update(payment, :sparse => true)

    update_response.total.should == 40.0
  end

  it "can delete a payment" do
    stub_http_request(:post,
                 "#{@service.url_for_resource(resource)}?operation=delete",
                 ["200", "OK"],
                 fixture("payment_delete_success_response.xml"))

    response = @service.delete(payment)

    response.should be_true
  end

  it 'can void a payment' do
    stub_http_request(:post,
                 "#{@service.url_for_resource(resource)}?include=void",
                 ["200", "OK"],
                 fixture("payment_void_response_success.xml"))

    response = @service.void(payment)

    response.should be_true
    response.total.should == 0
  end

  it "properly outputs BigDecimal fields" do
    payment.total = payment.unapplied_amount = payment.exchange_rate = "42"

    xml = payment.to_xml

    xml.at("TotalAmt").text.should == "42.0"
    xml.at("UnappliedAmt").text.should == "42.0"
    xml.at("ExchangeRate").text.should == "42.0"
  end
end
