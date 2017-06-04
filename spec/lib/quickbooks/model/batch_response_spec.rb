require 'spec_helper'

describe Quickbooks::Model::BatchResponse do
  it "parse from XML" do
    xml = fixture("batch_response.xml")
    batch_response = Quickbooks::Model::BatchResponse.from_xml(xml)
    batch_response.response_items.size.should == 9

    item_res1 = batch_response.response_items.first
    item_res1.bId.should == "1a"
    item_res1.should be_a_fault
    item_res1.fault.errors.size.should == 2

    item_res2 = batch_response.response_items[1]
    item_res2.bId.should == "2b"
    item_res2.should_not be_a_fault
    item_res2.customer.should_not be_nil
    item_res2.customer.id.should == "19891"

    item_res3 = batch_response.response_items[2]
    item_res3.bId.should == "3c"
    item_res3.should_not be_a_fault
    item_res3.item.should_not be_nil
    item_res3.item.id.should == "19891"

    item_res4 = batch_response.response_items[3]
    item_res4.account.should_not be_nil

    item_res5 = batch_response.response_items[4]
    item_res5.invoice.should_not be_nil

    item_res6 = batch_response.response_items[5]
    item_res6.sales_receipt.should_not be_nil

    item_res7 = batch_response.response_items[6]
    item_res7.payment.should_not be_nil

    item_res8 = batch_response.response_items[7]
    item_res8.time_activity.should_not be_nil

    item_res9 = batch_response.response_items[8]
    item_res9.journal_entry.should_not be_nil
  end
end
