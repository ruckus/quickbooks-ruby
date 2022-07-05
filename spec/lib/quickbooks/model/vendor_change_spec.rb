require 'nokogiri'

describe "Quickbooks::Model::VendorChange" do
  it "parse from XML" do
    xml = fixture("vendor_change.xml")
    vendor = Quickbooks::Model::VendorChange.from_xml(xml)
    expect(vendor.status).to eq('Deleted')
    expect(vendor.id).to eq("39")

    expect(vendor.meta_data).not_to be_nil
    expect(vendor.meta_data.last_updated_time).to eq(DateTime.parse("2014-12-08T19:36:24-08:00"))
  end
end