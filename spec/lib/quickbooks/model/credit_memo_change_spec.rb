require 'nokogiri'

describe "Quickbooks::Model::CreditMemoChange" do
  it "parse from XML" do
    xml = fixture("credit_memo_change.xml")
    credit_memo = Quickbooks::Model::CreditMemoChange.from_xml(xml)
    expect(credit_memo.status).to eq('Deleted')
    expect(credit_memo.id).to eq("39")

    expect(credit_memo.meta_data).not_to be_nil
    expect(credit_memo.meta_data.last_updated_time).to eq(DateTime.parse("2014-12-08T19:36:24-08:00"))
  end
end
