describe "Quickbooks::Service::RefundReceiptChange" do
  let(:service) { construct_service :refund_receipt_change }

  it "can query for refund_receipts" do
    xml = fixture("refund_receipt_changes.xml")
    model = Quickbooks::Model::RefundReceiptChange

    stub_http_request(:get, service.url_for_query, ["200", "OK"], xml)
    refund_receipts = service.query
    expect(refund_receipts.entries.count).to eq(1)

    first_refund_receipt = refund_receipts.entries.first
    expect(first_refund_receipt.status).to eq('Deleted')
    expect(first_refund_receipt.id).to eq("40")

    expect(first_refund_receipt.meta_data).not_to be_nil
    expect(first_refund_receipt.meta_data.last_updated_time).to eq(DateTime.parse("2014-12-09T19:30:24-08:00"))
  end

  describe "#url_for_query" do
    subject { service.url_for_query }
    it { is_expected.to eq "#{service.url_for_base}/cdc?entities=RefundReceipt" }
  end

end
