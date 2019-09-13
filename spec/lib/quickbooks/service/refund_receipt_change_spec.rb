describe "Quickbooks::Service::RefundReceiptChange" do
  let(:service) { construct_service :refund_receipt_change }

  it "can query for refund_receipts" do
    xml = fixture("refund_receipt_changes.xml")
    model = Quickbooks::Model::RefundReceiptChange

    stub_http_request(:get, service.url_for_query, ["200", "OK"], xml)
    refund_receipts = service.query
    refund_receipts.entries.count.should == 1

    first_refund_receipt = refund_receipts.entries.first
    first_refund_receipt.status.should == 'Deleted'
    first_refund_receipt.id.should == "40"

    first_refund_receipt.meta_data.should_not be_nil
    first_refund_receipt.meta_data.last_updated_time.should == DateTime.parse("2014-12-09T19:30:24-08:00")
  end

  describe "#url_for_query" do
    subject { service.url_for_query }
    it { should eq "#{service.url_for_base}/cdc?entities=RefundReceipt" }
  end

end
