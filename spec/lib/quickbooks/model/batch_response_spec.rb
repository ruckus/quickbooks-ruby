require 'spec_helper'

describe Quickbooks::Model::BatchResponse do
  it "parse from XML" do
    xml = fixture("batch_response.xml")
    batch_response = Quickbooks::Model::BatchResponse.from_xml(xml)
    expect(batch_response.response_items.size).to eq 9

    item_res1 = batch_response.response_items.first
    expect(item_res1.bId).to eq "1a"
    expect(item_res1).to be_a_fault
    expect(item_res1.fault.errors.size).to eq 2

    item_res2 = batch_response.response_items[1]
    expect(item_res2.bId).to eq "2b"
    expect(item_res2).to_not be_a_fault
    expect(item_res2.customer).to_not be_nil
    expect(item_res2.customer.id).to eq "19891"

    item_res3 = batch_response.response_items[2]
    expect(item_res3.bId).to eq "3c"
    expect(item_res3).to_not be_a_fault
    expect(item_res3.item).to_not be_nil
    expect(item_res3.item.id).to eq "19891"

    item_res4 = batch_response.response_items[3]
    expect(item_res4.account).to_not be_nil

    item_res5 = batch_response.response_items[4]
    expect(item_res5.invoice).to_not be_nil

    item_res6 = batch_response.response_items[5]
    expect(item_res6.sales_receipt).to_not be_nil

    item_res7 = batch_response.response_items[6]
    expect(item_res7.payment).to_not be_nil

    item_res8 = batch_response.response_items[7]
    expect(item_res8.time_activity).to_not be_nil

    item_res9 = batch_response.response_items[8]
    expect(item_res9.journal_entry).to_not be_nil
  end
end
