require 'nokogiri'

describe "Quickbooks::Model::PaymentChange" do
  it "parse from XML" do
    xml = fixture("payment_change.xml")
    payment = Quickbooks::Model::PaymentChange.from_xml(xml)
    payment.status.should == 'Deleted'
    payment.id.should == "39"

    payment.meta_data.should_not be_nil
    payment.meta_data.last_updated_time.should == DateTime.parse("2014-12-08T19:36:24-08:00")
  end
end
