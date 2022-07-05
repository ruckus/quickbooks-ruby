require 'nokogiri'

describe "Quickbooks::Model::ItemChange" do
  it "parse from XML" do
    xml = fixture("item_change.xml")
    item = Quickbooks::Model::ItemChange.from_xml(xml)
    expect(item.status).to eq('Deleted')
    expect(item.id).to eq("39")

    expect(item.meta_data).not_to be_nil
    expect(item.meta_data.last_updated_time).to eq(DateTime.parse("2014-12-08T19:36:24-08:00"))
  end
end