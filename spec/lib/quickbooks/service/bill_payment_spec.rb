describe "Quickbooks::Service::BillPayment" do
  before(:all) { construct_service :bill_payment }

  let(:vendor_ref) { Quickbooks::Model::BaseReference.new(32) }
  let(:model) { Quickbooks::Model::BillPayment }
  let(:bill_payment) do
    subject = model.new :id => 8748, :vendor_ref => vendor_ref
    subject.line_items = [Quickbooks::Model::BillPaymentLineItem.new]

    subject
  end
  let(:resource) { model::REST_RESOURCE }

  it "can query for bill payments" do
    stub_http_request(:get,
                 @service.url_for_query,
                 ["200", "OK"],
                 fixture("bill_payments.xml"))

    bill_payments = @service.query

    expect(bill_payments.entries.count).to eq(1)
    first_bill_payment = bill_payments.entries.first
    expect(first_bill_payment.private_note).to eq("Acct. 1JK90")
  end

  it "can fetch a bill_payment by ID" do
    stub_http_request(:get,
                 "#{@service.url_for_resource(resource)}/623",
                 ["200", "OK"],
                 fixture("fetch_bill_payment_by_id.xml"))

    bill_payment = @service.fetch_by_id(623)

    expect(bill_payment.private_note).to eq("Acct. 1JK90")
  end

  it "can create a bill_payment" do
    stub_http_request(:post,
                 @service.url_for_resource(resource),
                 ["200", "OK"],
                 fixture("fetch_bill_payment_by_id.xml"))

    created_bill_payment = @service.create(bill_payment)

    expect(created_bill_payment.id).to eq("623")
  end

  it "can sparse update a bill_payment" do
    bill_payment.total = 50.0
    stub_http_request(:post,
                 @service.url_for_resource(resource),
                 ["200", "OK"],
                 fixture("fetch_bill_payment_by_id.xml"),
                 {},
                 true)

    update_response = @service.update(bill_payment, :sparse => true)

    expect(update_response.total).to eq(110.0)
  end

  it "can delete a bill_payment" do
    stub_http_request(:post,
                 "#{@service.url_for_resource(resource)}?operation=delete",
                 ["200", "OK"],
                 fixture("bill_payment_delete_success_response.xml"))

    response = @service.delete(bill_payment)

    expect(response).to be true
  end
end
