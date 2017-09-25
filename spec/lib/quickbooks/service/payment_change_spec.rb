describe "Quickbooks::Service::PaymentChange" do
  let(:service) { construct_service :payment_change }

  it "can query for payments" do
    xml = fixture("payment_changes.xml")
    model = Quickbooks::Model::PaymentChange

    stub_http_request(:get, service.url_for_query, ["200", "OK"], xml)
    payments = service.query
    payments.entries.count.should == 1

    first_payment = payments.entries.first
    first_payment.status.should == 'Deleted'
    first_payment.id.should == "39"

    first_payment.meta_data.should_not be_nil
    first_payment.meta_data.last_updated_time.should == DateTime.parse("2014-12-08T19:36:24-08:00")
  end

  describe "#url_for_query" do
    subject { service.url_for_query }
    it { should eq "#{service.url_for_base}/cdc?entities=Payment" }
  end

end
