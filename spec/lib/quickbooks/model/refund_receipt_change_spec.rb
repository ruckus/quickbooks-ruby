require 'nokogiri'

describe "Quickbooks::Model::RefundReceiptChange" do
  it "parse from XML" do
    xml = fixture("refund_receipt_change.xml")
    refund_receipt = Quickbooks::Model::RefundReceiptChange.from_xml(xml)
    refund_receipt.status.should == 'Deleted'
    refund_receipt.id.should == "40"

    refund_receipt.meta_data.should_not be_nil
    refund_receipt.meta_data.last_updated_time.should == DateTime.parse("2014-12-09T19:30:24-08:00")
  end
end
