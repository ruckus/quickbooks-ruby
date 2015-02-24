require 'nokogiri'

describe "Quickbooks::Model::ItemChange" do
  it "parse from XML" do
    xml = fixture("item_change.xml")
    item = Quickbooks::Model::ItemChange.from_xml(xml)
    item.status.should == 'Deleted'
    item.id.should == 39

    item.meta_data.should_not be_nil
    item.meta_data.last_updated_time.should == DateTime.parse("2014-12-08T19:36:24-08:00")
  end
end