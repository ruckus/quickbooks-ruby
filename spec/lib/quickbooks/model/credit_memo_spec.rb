require 'nokogiri'

describe "Quickbooks::Model::CreditMemo" do

  it "should have line items" do
    credit_memo = Quickbooks::Model::CreditMemo.new
    credit_memo.line_items.should be_kind_of(Array)
    credit_memo.valid?.should == false
    credit_memo.errors.keys.include?(:line_items).should == true
  end

  it "should not be valid if empty line item" do
    credit_memo = Quickbooks::Model::CreditMemo.new
    credit_memo.valid?
    expect(credit_memo.errors[:line_items].first).to match /At least 1 line item is required/
  end

  it "should set the transaction date" do
    credit_memo = Quickbooks::Model::CreditMemo.new
    current = Time.now
    credit_memo.txn_date = current
    credit_memo.to_xml.to_s.should =~ /TxnDate.*#{current.to_s[0..-6]}/ # shave off utc offset as Travis doesn't like
  end

  describe "#auto_doc_number" do
    it_should_behave_like "a model that has auto_doc_number support", 'CreditMemo'
  end

  it "should set the transaction tax reference" do
    credit_memo = Quickbooks::Model::CreditMemo.new
    tax_detail = Quickbooks::Model::TransactionTaxDetail.new
    tax_detail.txn_tax_code_id = 5
    credit_memo.txn_tax_detail = tax_detail
    credit_memo.to_xml.to_s.should =~ /TxnTaxCodeRef\>5\</
  end

  describe "#global_tax_calculation" do
    subject { Quickbooks::Model::CreditMemo.new }
    it_should_behave_like "a model with a valid GlobalTaxCalculation", "TaxInclusive"
    it_should_behave_like "a model with a valid GlobalTaxCalculation", "TaxExcluded"
    it_should_behave_like "a model with a valid GlobalTaxCalculation", "NotApplicable"
    it_should_behave_like "a model with a valid GlobalTaxCalculation", ""
    it_should_behave_like "a model with an invalid GlobalTaxCalculation"
  end

end
