describe "Quickbooks::Service::PaymentChange" do
  let(:service) { construct_service :payment_change }

  it "can query for payments" do
    xml = fixture("payment_changes.xml")
    model = Quickbooks::Model::PaymentChange

    stub_http_request(:get, service.url_for_query, ["200", "OK"], xml)
    payments = service.query
    expect(payments.entries.count).to eq(1)

    first_payment = payments.entries.first
    expect(first_payment.status).to eq('Deleted')
    expect(first_payment.id).to eq("39")

    expect(first_payment.meta_data).not_to be_nil
    expect(first_payment.meta_data.last_updated_time).to eq(DateTime.parse("2014-12-08T19:36:24-08:00"))
  end

  describe "#url_for_query" do
    subject { service.url_for_query }
    it { is_expected.to eq "#{service.url_for_base}/cdc?entities=Payment" }
  end

end
