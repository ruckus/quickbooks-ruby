require 'nokogiri'

describe "Quickbooks::Model::InvoiceChange" do
  it "parse from XML" do
    xml = fixture("invoice_change.xml")
    invoice = Quickbooks::Model::InvoiceChange.from_xml(xml)
    expect(invoice.status).to eq('Deleted')
    expect(invoice.id).to eq("39")

    expect(invoice.meta_data).not_to be_nil
    expect(invoice.meta_data.last_updated_time).to eq(DateTime.parse("2014-12-08T19:36:24-08:00"))
  end
end