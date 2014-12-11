require 'nokogiri'

describe "Quickbooks::Model::InvoiceChange" do
  it "parse from XML" do
    xml = fixture("invoice_change.xml")
    invoice = Quickbooks::Model::InvoiceChange.from_xml(xml)
    invoice.status.should == 'Deleted'
    invoice.id.should == 39

    invoice.meta_data.should_not be_nil
    invoice.meta_data.last_updated_time.should == DateTime.parse("2014-12-08T19:36:24-08:00")
  end
end