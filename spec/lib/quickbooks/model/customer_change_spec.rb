require 'nokogiri'

describe "Quickbooks::Model::CustomerChange" do
  it "parse from XML" do
    xml = fixture("customer_change.xml")
    customer = Quickbooks::Model::CustomerChange.from_xml(xml)
    expect(customer.status).to eq('Deleted')
    expect(customer.id).to eq("39")

    expect(customer.meta_data).not_to be_nil
    expect(customer.meta_data.last_updated_time).to eq(DateTime.parse("2014-12-08T19:36:24-08:00"))
  end
end