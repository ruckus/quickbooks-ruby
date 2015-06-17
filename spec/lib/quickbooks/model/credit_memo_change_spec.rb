require 'nokogiri'

describe "Quickbooks::Model::CreditMemoChange" do
  it "parse from XML" do
    xml = fixture("credit_memo_change.xml")
    credit_memo = Quickbooks::Model::CreditMemoChange.from_xml(xml)
    credit_memo.status.should == 'Deleted'
    credit_memo.id.should == "39"

    credit_memo.meta_data.should_not be_nil
    credit_memo.meta_data.last_updated_time.should == DateTime.parse("2014-12-08T19:36:24-08:00")
  end
end
