require 'nokogiri'

describe "Quickbooks::Model::RefundReceiptChange" do
  it "parse from XML" do
    xml = fixture("refund_receipt_change.xml")
    refund_receipt = Quickbooks::Model::RefundReceiptChange.from_xml(xml)
    expect(refund_receipt.status).to eq('Deleted')
    expect(refund_receipt.id).to eq("40")

    expect(refund_receipt.meta_data).not_to be_nil
    expect(refund_receipt.meta_data.last_updated_time).to eq(DateTime.parse("2014-12-09T19:30:24-08:00"))
  end
end
