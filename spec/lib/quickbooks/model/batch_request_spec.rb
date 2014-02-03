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
end
