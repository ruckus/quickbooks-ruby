require 'nokogiri'

describe "Quickbooks::Model::CreditMemo" do

  it "should have line items" do
    credit_memo = Quickbooks::Model::CreditMemo.new
    credit_memo.line_items.should be_kind_of(Array)
    credit_memo.valid?.should == false
    credit_memo.errors.keys.include?(:line_items).should == true
  end

  it "should set the transaction date" do
    credit_memo = Quickbooks::Model::CreditMemo.new
    current = Time.now
    credit_memo.placed_on = current
    credit_memo.to_xml.to_s.should =~ /TxnDate.*#{current}/
  end

end
