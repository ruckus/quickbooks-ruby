describe "Quickbooks::Model::Purchase" do

  it "parse from XML (cash)" do
    xml = fixture("purchase_cash_response.xml")
    purchase = Quickbooks::Model::Purchase.from_xml(xml)
    expect(purchase.sync_token).to eq(0)
    expect(purchase.txn_date.to_date).to eq(Date.civil(2013,1,4))
    expect(purchase.total_amount).to eq(11.05)
    expect(purchase.payment_type).to eq("Cash")

    expect(purchase.account_ref.value).to eq("64")
    expect(purchase.account_ref.name).to eq("Test Purchase Bank Account")
    expect(purchase.entity_ref.value).to eq("1")
    expect(purchase.entity_ref.name).to eq("Mr V3 Service Customer Jr2")

    expect(purchase.line_items.size).to eq(2)

    line1 = purchase.line_items[0]
    expect(line1.detail_type).to eq("AccountBasedExpenseLineDetail")
    expect(line1.id).to eq("1")
    expect(line1.amount).to eq(10.0)
    expect(line1.description).to eq("this is line 1")
    expect(line1.account_based_expense_line_detail.account_ref.value).to eq("60")
    expect(line1.account_based_expense_line_detail.account_ref.name).to eq("Advertising")
    expect(line1.account_based_expense_line_detail.billable_status).to eq("NotBillable")
    expect(line1.account_based_expense_line_detail.tax_code_ref.value).to eq("3")

    line2 = purchase.line_items[1]
    expect(line2.detail_type).to eq("ItemBasedExpenseLineDetail")
    expect(line2.id).to eq("2")
    expect(line2.amount).to eq(1.0)
    expect(line2.description).to eq("this is item line 1")
    expect(line2.item_based_expense_line_detail.quantity).to eq(1)
    expect(line2.item_based_expense_line_detail.tax_code_ref.value).to eq("5")
    expect(line2.item_based_expense_line_detail.billable_status).to eq("NotBillable")
    expect(line2.item_based_expense_line_detail.item_ref.value).to eq("3")
    expect(line2.item_based_expense_line_detail.item_ref.name).to eq("Test Purchase Item")
    expect(line2.account_based_expense_line_detail.account_ref.value).to eq("62")
    expect(line2.account_based_expense_line_detail.account_ref.name).to eq("Test Purchase Expense Account")

    expect(purchase.txn_tax_detail.lines.size).to eq(3)

    tax_line1 = purchase.txn_tax_detail.lines[0]
    expect(tax_line1.detail_type).to eq("TaxLineDetail")
    expect(tax_line1.amount).to eq(2.0)
    expect(tax_line1.tax_line_detail.tax_rate_ref.value).to eq("4")
    expect(tax_line1.tax_line_detail.percent_based?).to be true
    expect(tax_line1.tax_line_detail.tax_percent).to eq(20)
    expect(tax_line1.tax_line_detail.net_amount_taxable).to eq(10.0)

    tax_line2 = purchase.txn_tax_detail.lines[1]
    expect(tax_line2.detail_type).to eq("TaxLineDetail")
    expect(tax_line2.amount).to eq(-2.0)
    expect(tax_line2.tax_line_detail.tax_rate_ref.value).to eq("3")
    expect(tax_line2.tax_line_detail.percent_based?).to be true
    expect(tax_line2.tax_line_detail.tax_percent).to eq(-20)
    expect(tax_line2.tax_line_detail.net_amount_taxable).to eq(10.0)

    tax_line3 = purchase.txn_tax_detail.lines[2]
    expect(tax_line3.detail_type).to eq("TaxLineDetail")
    expect(tax_line3.amount).to eq(0.05)
    expect(tax_line3.tax_line_detail.tax_rate_ref.value).to eq("8")
    expect(tax_line3.tax_line_detail.percent_based?).to be true
    expect(tax_line3.tax_line_detail.tax_percent).to eq(5)
    expect(tax_line3.tax_line_detail.net_amount_taxable).to eq(1.0)
  end

  it "parse from XML (check)" do
    xml = fixture("purchase_check_response.xml")
    purchase = Quickbooks::Model::Purchase.from_xml(xml)
    expect(purchase.sync_token).to eq(0)
    expect(purchase.txn_date.to_date).to eq(Date.civil(2013,1,4))
    expect(purchase.total_amount).to eq(11.05)
    expect(purchase.payment_type).to eq("Check")

    expect(purchase.account_ref.value).to eq("61")
    expect(purchase.account_ref.name).to eq("Test Purchase Bank Account")
    expect(purchase.entity_ref.value).to eq("1")
    expect(purchase.entity_ref.name).to eq("Mr V3 Service Customer Jr2")
    expect(purchase.entity_ref.type).to eq("Customer")

    expect(purchase.remit_to_address.id).to eq("2")
    expect(purchase.remit_to_address.line1).to eq("Google")
    expect(purchase.remit_to_address.line2).to eq("Building 1")
    expect(purchase.remit_to_address.line3).to eq("123 street")
    expect(purchase.remit_to_address.line4).to eq("Dept 12")
    expect(purchase.remit_to_address.line5).to eq("Cube 999")
    expect(purchase.remit_to_address.city).to eq("Mountain View")
    expect(purchase.remit_to_address.country).to eq("USA")
    expect(purchase.remit_to_address.country_sub_division_code).to eq("CA")
    expect(purchase.remit_to_address.postal_code).to eq("95123")

    expect(purchase.line_items.size).to eq(2)

    line1 = purchase.line_items[0]
    expect(line1.detail_type).to eq("AccountBasedExpenseLineDetail")
    expect(line1.id).to eq("1")
    expect(line1.amount).to eq(10.0)
    expect(line1.description).to eq("this is line 1")
    expect(line1.account_based_expense_line_detail.account_ref.value).to eq("60")
    expect(line1.account_based_expense_line_detail.account_ref.name).to eq("Advertising")
    expect(line1.account_based_expense_line_detail.billable_status).to eq("NotBillable")
    expect(line1.account_based_expense_line_detail.tax_code_ref.value).to eq("3")

    line2 = purchase.line_items[1]
    expect(line2.detail_type).to eq("ItemBasedExpenseLineDetail")
    expect(line2.id).to eq("2")
    expect(line2.amount).to eq(1.0)
    expect(line2.description).to eq("this is item line 1")
    expect(line2.item_based_expense_line_detail.quantity).to eq(1)
    expect(line2.item_based_expense_line_detail.tax_code_ref.value).to eq("5")
    expect(line2.item_based_expense_line_detail.billable_status).to eq("NotBillable")
    expect(line2.item_based_expense_line_detail.item_ref.value).to eq("3")
    expect(line2.item_based_expense_line_detail.item_ref.name).to eq("Test Purchase Item")
    expect(line2.account_based_expense_line_detail.account_ref.value).to eq("62")
    expect(line2.account_based_expense_line_detail.account_ref.name).to eq("Test Purchase Expense Account")

    expect(purchase.txn_tax_detail.lines.size).to eq(3)

    tax_line1 = purchase.txn_tax_detail.lines[0]
    expect(tax_line1.detail_type).to eq("TaxLineDetail")
    expect(tax_line1.amount).to eq(2.0)
    expect(tax_line1.tax_line_detail.tax_rate_ref.value).to eq("4")
    expect(tax_line1.tax_line_detail.percent_based?).to be true
    expect(tax_line1.tax_line_detail.tax_percent).to eq(20)
    expect(tax_line1.tax_line_detail.net_amount_taxable).to eq(10.0)

    tax_line2 = purchase.txn_tax_detail.lines[1]
    expect(tax_line2.detail_type).to eq("TaxLineDetail")
    expect(tax_line2.amount).to eq(-2.0)
    expect(tax_line2.tax_line_detail.tax_rate_ref.value).to eq("3")
    expect(tax_line2.tax_line_detail.percent_based?).to be true
    expect(tax_line2.tax_line_detail.tax_percent).to eq(-20)
    expect(tax_line2.tax_line_detail.net_amount_taxable).to eq(10.0)

    tax_line3 = purchase.txn_tax_detail.lines[2]
    expect(tax_line3.detail_type).to eq("TaxLineDetail")
    expect(tax_line3.amount).to eq(0.05)
    expect(tax_line3.tax_line_detail.tax_rate_ref.value).to eq("8")
    expect(tax_line3.tax_line_detail.percent_based?).to be true
    expect(tax_line3.tax_line_detail.tax_percent).to eq(5)
    expect(tax_line3.tax_line_detail.net_amount_taxable).to eq(1.0)
  end

  it "parse from XML (credit_card)" do
    xml = fixture("purchase_credit_card_response.xml")
    purchase = Quickbooks::Model::Purchase.from_xml(xml)
    expect(purchase.sync_token).to eq(0)
    expect(purchase.txn_date.to_date).to eq(Date.civil(2013,1,4))
    expect(purchase.total_amount).to eq(0)
    expect(purchase.payment_type).to eq("CreditCard")

    expect(purchase.account_ref.value).to eq("64")
    expect(purchase.account_ref.name).to eq("Test Purchase Credit Card Account")
    expect(purchase.entity_ref.value).to eq("1")
    expect(purchase.entity_ref.name).to eq("Mr V3 Service Customer Jr2")

    expect(purchase.line_items.size).to eq(1)

    line1 = purchase.line_items[0]
    expect(line1.detail_type).to eq("AccountBasedExpenseLineDetail")
    expect(line1.id).to eq("1")
    expect(line1.amount).to eq(0)
    expect(line1.description).to eq("this is description only.")
    expect(line1.account_based_expense_line_detail.account_ref.value).to eq("60")
    expect(line1.account_based_expense_line_detail.account_ref.name).to eq("Advertising")
    expect(line1.account_based_expense_line_detail.billable_status).to eq("NotBillable")
    expect(line1.account_based_expense_line_detail.tax_code_ref.value).to eq("NON")
  end

  describe "#global_tax_calculation" do
    subject { Quickbooks::Model::Purchase.new }
    it_should_behave_like "a model with a valid GlobalTaxCalculation", "TaxInclusive"
    it_should_behave_like "a model with a valid GlobalTaxCalculation", "TaxExcluded"
    it_should_behave_like "a model with a valid GlobalTaxCalculation", "NotApplicable"
    it_should_behave_like "a model with a valid GlobalTaxCalculation", ""
    it_should_behave_like "a model with an invalid GlobalTaxCalculation"
  end
end
