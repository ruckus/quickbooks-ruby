describe "Quickbooks::Model::VendorCredit" do

  it "parse from XML" do
    xml = fixture("vendor_credit.xml")
    vendor_credit = Quickbooks::Model::VendorCredit.from_xml(xml)
    expect(vendor_credit.sync_token).to eq(0)
    expect(vendor_credit.id).to eq("11")
    expect(vendor_credit.txn_date.to_date).to eq(Date.civil(2013,9,20))
    expect(vendor_credit.total_amount).to eq(90.0)

    expect(vendor_credit.vendor_ref.value).to eq("5")
    expect(vendor_credit.vendor_ref.name).to eq("myVendor")
    expect(vendor_credit.ap_account_ref.value).to eq("38")
    expect(vendor_credit.ap_account_ref.name).to eq("Accounts Payable (A/P)")

    expect(vendor_credit.line_items.size).to eq(1)

    line1 = vendor_credit.line_items[0]
    expect(line1.detail_type).to eq("AccountBasedExpenseLineDetail")
    expect(line1.id).to eq("1")
    expect(line1.amount).to eq(90.0)
    expect(line1.account_based_expense_line_detail.customer_ref.value).to eq("2")
    expect(line1.account_based_expense_line_detail.customer_ref.name).to eq("Cust1")
    expect(line1.account_based_expense_line_detail.account_ref.value).to eq("8")
    expect(line1.account_based_expense_line_detail.account_ref.name).to eq("Bank Charges")
    expect(line1.account_based_expense_line_detail.billable_status).to eq("Billable")
    expect(line1.account_based_expense_line_detail.tax_code_ref.value).to eq("TAX")
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
