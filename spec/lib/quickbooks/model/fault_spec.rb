require 'spec_helper'

describe Quickbooks::Model::Fault do
  it "should parse from xml" do
    fault_xml = fixture("fault.xml")
    fault = Quickbooks::Model::Fault.from_xml(fault_xml)
    expect(fault.errors.size).to eq(2)
    first_error = fault.errors.first
    expect(first_error.code).to eq("2050")
    expect(first_error.element).to eq("firstname")
    expect(first_error.message).to eq("Length exceeds limit")
    expect(first_error.detail).to eq("Length of the field exceeds 21 chars")
    last_error = fault.errors.last
    expect(last_error.code).to eq("2080")
    expect(last_error.element).to eq("postalcode")
    expect(last_error.message).to eq("Illegal number format")
    expect(last_error.detail).to eq("ZipCode should be a number with at least 5 digits")
  end
end
