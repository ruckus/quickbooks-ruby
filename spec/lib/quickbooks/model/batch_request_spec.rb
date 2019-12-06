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

    expect(Hash.from_xml(req.to_xml.to_s)).to eq Hash.from_xml(ex_req.to_xml.to_s)
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

    expect(Hash.from_xml(req.to_xml.to_s)).to eq Hash.from_xml(ex_req.to_xml.to_s)
  end

  it "should add account" do
    req = Quickbooks::Model::BatchRequest.new
    account = Quickbooks::Model::Account.new
    req.add("1", account, 'create')
    expect(req.request_items.first.account).to be_a Quickbooks::Model::Account
  end

  it "should add invoice" do
    req = Quickbooks::Model::BatchRequest.new
    invoice = Quickbooks::Model::Invoice.new
    req.add("1", invoice, 'create')
    expect(req.request_items.first.invoice).to be_a Quickbooks::Model::Invoice
  end

  it "should add bill" do
    req = Quickbooks::Model::BatchRequest.new
    bill = Quickbooks::Model::Bill.new
    req.add("1", bill, 'create')
    expect(req.request_items.first.bill).to be_a Quickbooks::Model::Bill
  end

  it "should add sales_receipt" do
    req = Quickbooks::Model::BatchRequest.new
    sales_receipt = Quickbooks::Model::SalesReceipt.new
    req.add("1", sales_receipt, 'create')
    expect(req.request_items.first.sales_receipt).to be_a Quickbooks::Model::SalesReceipt
  end

  it "should add payment" do
    req = Quickbooks::Model::BatchRequest.new
    payment = Quickbooks::Model::Payment.new
    req.add("1", payment, 'create')
    expect(req.request_items.first.payment).to be_a Quickbooks::Model::Payment
  end

  it "should add time_activity" do
    req = Quickbooks::Model::BatchRequest.new
    time_activity = Quickbooks::Model::TimeActivity.new
    req.add("1", time_activity, 'create')
    expect(req.request_items.first.time_activity).to be_a Quickbooks::Model::TimeActivity
  end

  it "should add a journal_entry" do
    req = Quickbooks::Model::BatchRequest.new
    journal_entry = Quickbooks::Model::JournalEntry.new
    req.add("1", journal_entry, 'create')
    expect(req.request_items.first.journal_entry).to be_a Quickbooks::Model::JournalEntry
  end
end
