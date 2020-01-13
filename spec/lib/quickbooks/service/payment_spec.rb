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

    expect(payments.entries.count).to eq(1)
    payment = payments.entries.first
    expect(payment.private_note).to eq("H60jzmw0Uq")
  end

  it "can fetch a payment by ID" do
    stub_http_request(:get,
                 "#{@service.url_for_resource(resource)}/1",
                 ["200", "OK"],
                 fixture("payment_by_id.xml"))

    payment = @service.fetch_by_id(1)

    expect(payment.private_note).to eq("H60jzmw0Uq")
  end

  it "can create a payment" do
    stub_http_request(:post,
                 @service.url_for_resource(resource),
                 ["200", "OK"],
                 fixture("fetch_payment_by_id.xml"))

    created_payment = @service.create(payment)

    expect(created_payment.id).to eq("8748")
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

    expect(update_response.total).to eq(40.0)
  end

  it "can delete a payment" do
    stub_http_request(:post,
                 "#{@service.url_for_resource(resource)}?operation=delete",
                 ["200", "OK"],
                 fixture("payment_delete_success_response.xml"))

    response = @service.delete(payment)

    expect(response).to be true
  end

  it 'can void a payment' do
    stub_http_request(:post,
                 "#{@service.url_for_resource(resource)}?include=void",
                 ["200", "OK"],
                 fixture("payment_void_response_success.xml"))

    response = @service.void(payment)

    expect(response).to be_truthy
    expect(response.total).to eq(0)
  end

  it "properly outputs BigDecimal fields" do
    payment.total = payment.unapplied_amount = payment.exchange_rate = "42"

    xml = payment.to_xml

    expect(xml.at("TotalAmt").text).to eq("42.0")
    expect(xml.at("UnappliedAmt").text).to eq("42.0")
    expect(xml.at("ExchangeRate").text).to eq("42.0")
  end
end
