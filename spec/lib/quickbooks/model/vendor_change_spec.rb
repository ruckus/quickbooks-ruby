require 'nokogiri'

describe "Quickbooks::Model::VendorChange" do
  it "parse from XML" do
    xml = fixture("vendor_change.xml")
    vendor = Quickbooks::Model::VendorChange.from_xml(xml)
    vendor.status.should == 'Deleted'
    vendor.id.should == 39

    vendor.meta_data.should_not be_nil
    vendor.meta_data.last_updated_time.should == DateTime.parse("2014-12-08T19:36:24-08:00")
  end
end