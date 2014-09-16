require 'spec_helper'

describe Quickbooks::Model::Fault do
  it "should parse from xml" do
    fault_xml = fixture("fault.xml")
    fault = Quickbooks::Model::Fault.from_xml(fault_xml)
    fault.errors.size.should == 2
    first_error = fault.errors.first
    first_error.code.should == "2050"
    first_error.message.should == "Length exceeds limit"
    first_error.detail.should == "Length of the field exceeds 21 chars"
    last_error = fault.errors.last
    last_error.code.should == "2080"
    last_error.message.should == "Illegal number format"
    last_error.detail.should == "ZipCode should be a number with at least 5 digits"
  end
end
