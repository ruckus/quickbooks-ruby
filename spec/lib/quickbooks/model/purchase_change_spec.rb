require 'nokogiri'

describe "Quickbooks::Model::PurchaseChange" do
  it "parse from XML" do
    xml = fixture("purchase_change.xml")
    purchase = Quickbooks::Model::PurchaseChange.from_xml(xml)
    expect(purchase.status).to eq('Deleted')
    expect(purchase.id).to eq("39")

    expect(purchase.meta_data).not_to be_nil
    expect(purchase.meta_data.last_updated_time).to eq(DateTime.parse("2014-12-08T19:36:24-08:00"))
  end
end
