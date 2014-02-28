require 'spec_helper'

describe Quickbooks::Model::BatchRequest do
  it 'should convert to xml' do
    req = Quickbooks::Model::BatchRequest.new
    cus1 = Quickbooks::Model::Customer.new
    cus1.given_name = "Some"
    cus1.family_name = "Customer"
    req.add("1", cus1, 'create')
    cus2 = Quickbooks::Model::Customer.new
    cus2.given_name = "Another"
    cus2.family_name = "Customer"
    req.add("2", cus2, 'update')

    ex_req = Nokogiri::XML("<IntuitBatchRequest/>").children.first
    bir1 = Nokogiri::XML("<BatchItemRequest bId=\"1\" operation=\"create\">").children.first
    bir1.add_child(cus1.to_xml)
    ex_req.add_child(bir1)
    bir2 = Nokogiri::XML("<BatchItemRequest bId=\"2\" operation=\"update\">").children.first
    bir2.add_child(cus2.to_xml)
    ex_req.add_child(bir2)

    Hash.from_xml(req.to_xml.to_s).should == Hash.from_xml(ex_req.to_xml.to_s)
  end

  it "should add item" do
    req = Quickbooks::Model::BatchRequest.new
    item1 = Quickbooks::Model::Item.new
    item1.name = "Some"
    req.add("1", item1, 'create')

    ex_req = Nokogiri::XML("<IntuitBatchRequest/>").children.first
    bir1 = Nokogiri::XML("<BatchItemRequest bId=\"1\" operation=\"create\">").children.first
    bir1.add_child(item1.to_xml)
    ex_req.add_child(bir1)

    Hash.from_xml(req.to_xml.to_s).should == Hash.from_xml(ex_req.to_xml.to_s)
  end

  it "should add account" do
    req = Quickbooks::Model::BatchRequest.new
    account = Quickbooks::Model::Account.new
    req.add("1", account, 'create')
    req.request_items.first.account.class.should == Quickbooks::Model::Account
  end

  it "should add invoice" do
    req = Quickbooks::Model::BatchRequest.new
    invoice = Quickbooks::Model::Invoice.new
    req.add("1", invoice, 'create')
    req.request_items.first.invoice.class.should == Quickbooks::Model::Invoice
  end

  it "should add bill" do
    req = Quickbooks::Model::BatchRequest.new
    bill = Quickbooks::Model::Bill.new
    req.add("1", bill, 'create')
    req.request_items.first.bill.class.should == Quickbooks::Model::Bill
  end

  it "should add sales_receipt" do
    req = Quickbooks::Model::BatchRequest.new
    sales_receipt = Quickbooks::Model::SalesReceipt.new
    req.add("1", sales_receipt, 'create')
    req.request_items.first.sales_receipt.class.should == Quickbooks::Model::SalesReceipt
  end
end
