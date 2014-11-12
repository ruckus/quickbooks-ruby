describe "Quickbooks::Model::VendorCredit" do

  it "parse from XML" do
    xml = fixture("vendor_credit.xml")
    vendor_credit = Quickbooks::Model::VendorCredit.from_xml(xml)
    vendor_credit.sync_token.should == 0
    vendor_credit.id.should == 11
    vendor_credit.txn_date.to_date.should == Date.civil(2013,9,20)
    vendor_credit.total_amount.should == 90.0

    vendor_credit.vendor_ref.value.should == "5"
    vendor_credit.vendor_ref.name.should == "myVendor"
    vendor_credit.ap_account_ref.value.should == "38"
    vendor_credit.ap_account_ref.name.should == "Accounts Payable (A/P)"

    vendor_credit.line_items.size.should == 1
    
    line1 = vendor_credit.line_items[0]
    line1.detail_type.should == "AccountBasedExpenseLineDetail"
    line1.id.should == 1
    line1.amount.should == 90.0
    line1.account_based_expense_line_detail.customer_ref.value.should == "2"
    line1.account_based_expense_line_detail.customer_ref.name.should == "Cust1"
    line1.account_based_expense_line_detail.account_ref.value.should == "8"
    line1.account_based_expense_line_detail.account_ref.name.should == "Bank Charges"
    line1.account_based_expense_line_detail.billable_status.should == "Billable"
    line1.account_based_expense_line_detail.tax_code_ref.value.should == "TAX"
  end

  describe "#global_tax_calculation" do
    subject { Quickbooks::Model::VendorCredit.new }
    it_should_behave_like "a model with a valid GlobalTaxCalculation", "TaxInclusive"
    it_should_behave_like "a model with a valid GlobalTaxCalculation", "TaxExcluded"
    it_should_behave_like "a model with a valid GlobalTaxCalculation", "NotApplicable"
    it_should_behave_like "a model with a valid GlobalTaxCalculation", ""
    it_should_behave_like "a model with an invalid GlobalTaxCalculation"
  end

end
