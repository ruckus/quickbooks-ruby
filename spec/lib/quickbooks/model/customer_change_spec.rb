require 'nokogiri'

describe "Quickbooks::Model::CustomerChange" do
  it "parse from XML" do
    xml = fixture("customer_change.xml")
    customer = Quickbooks::Model::CustomerChange.from_xml(xml)
    customer.status.should == 'Deleted'
    customer.id.should == "39"

    customer.meta_data.should_not be_nil
    customer.meta_data.last_updated_time.should == DateTime.parse("2014-12-08T19:36:24-08:00")
  end
end