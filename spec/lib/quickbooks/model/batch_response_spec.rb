require 'spec_helper'

describe Quickbooks::Model::BatchResponse do
  it "parse from XML" do
    xml = fixture("batch_response.xml")
    batch_response = Quickbooks::Model::BatchResponse.from_xml(xml)
    batch_response.response_items.size.should == 2
    item_res1 = batch_response.response_items.first
    item_res1.bId.should == "1a"
    item_res1.should be_a_fault
    item_res1.fault.errors.size.should == 2
    item_res2 = batch_response.response_items.last
    item_res2.bId.should == "2c"
    item_res2.should_not be_a_fault
    item_res2.customer.should_not be_nil
    item_res2.customer.id.should == 19891
  end
end
