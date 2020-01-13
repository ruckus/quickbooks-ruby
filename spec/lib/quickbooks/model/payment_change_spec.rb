require 'nokogiri'

describe "Quickbooks::Model::PaymentChange" do
  it "parse from XML" do
    xml = fixture("payment_change.xml")
    payment = Quickbooks::Model::PaymentChange.from_xml(xml)
    expect(payment.status).to eq('Deleted')
    expect(payment.id).to eq("39")

    expect(payment.meta_data).not_to be_nil
    expect(payment.meta_data.last_updated_time).to eq(DateTime.parse("2014-12-08T19:36:24-08:00"))
  end
end
