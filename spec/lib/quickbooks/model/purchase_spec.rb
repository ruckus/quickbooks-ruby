describe "Quickbooks::Model::Purchase" do

  it "parse from XML (cash)" do
    xml = fixture("purchase_cash_response.xml")
    purchase = Quickbooks::Model::Purchase.from_xml(xml)
    purchase.sync_token.should == 0
    purchase.txn_date.to_date.should == Date.civil(2013,1,4)
    purchase.total_amount.should == 11.05
    purchase.payment_type.should == "Cash"

    purchase.account_ref.value.should == "64"
    purchase.account_ref.name.should == "Test Purchase Bank Account"
    purchase.entity_ref.value.should == "1"
    purchase.entity_ref.name.should == "Mr V3 Service Customer Jr2"

    purchase.line_items.size.should == 2
    
    line1 = purchase.line_items[0]
    line1.detail_type.should == "AccountBasedExpenseLineDetail"
    line1.id.should == 1
    line1.amount.should == 10.0
    line1.description.should == "this is line 1"
    line1.account_based_expense_line_detail.account_ref.value.should == "60"
    line1.account_based_expense_line_detail.account_ref.name.should == "Advertising"
    line1.account_based_expense_line_detail.billable_status.should == "NotBillable"
    line1.account_based_expense_line_detail.tax_code_ref.value.should == "3"

    line2 = purchase.line_items[1]
    line2.detail_type.should == "ItemBasedExpenseLineDetail"
    line2.id.should == 2
    line2.amount.should == 1.0
    line2.description.should == "this is item line 1"
    line2.item_based_expense_line_detail.quantity.should == 1
    line2.item_based_expense_line_detail.tax_code_ref.value.should == "5"
    line2.item_based_expense_line_detail.billable_status.should == "NotBillable"
    line2.item_based_expense_line_detail.item_ref.value.should == "3"
    line2.item_based_expense_line_detail.item_ref.name.should == "Test Purchase Item"
    line2.account_based_expense_line_detail.account_ref.value.should == "62"
    line2.account_based_expense_line_detail.account_ref.name.should == "Test Purchase Expense Account"
  end

  it "parse from XML (check)" do
    xml = fixture("purchase_check_response.xml")
    purchase = Quickbooks::Model::Purchase.from_xml(xml)
    purchase.sync_token.should == 0
    purchase.txn_date.to_date.should == Date.civil(2013,1,4)
    purchase.total_amount.should == 11.05
    purchase.payment_type.should == "Check"

    purchase.account_ref.value.should == "61"
    purchase.account_ref.name.should == "Test Purchase Bank Account"
    purchase.entity_ref.value.should == "1"
    purchase.entity_ref.name.should == "Mr V3 Service Customer Jr2"

    purchase.remit_to_address.id.should == 2
    purchase.remit_to_address.line1.should == "Google"
    purchase.remit_to_address.line2.should == "Building 1"
    purchase.remit_to_address.line3.should == "123 street"
    purchase.remit_to_address.line4.should == "Dept 12"
    purchase.remit_to_address.line5.should == "Cube 999"
    purchase.remit_to_address.city.should == "Mountain View"
    purchase.remit_to_address.country.should == "USA"
    purchase.remit_to_address.country_sub_division_code.should == "CA"
    purchase.remit_to_address.postal_code.should == "95123"

    purchase.line_items.size.should == 2
    
    line1 = purchase.line_items[0]
    line1.detail_type.should == "AccountBasedExpenseLineDetail"
    line1.id.should == 1
    line1.amount.should == 10.0
    line1.description.should == "this is line 1"
    line1.account_based_expense_line_detail.account_ref.value.should == "60"
    line1.account_based_expense_line_detail.account_ref.name.should == "Advertising"
    line1.account_based_expense_line_detail.billable_status.should == "NotBillable"
    line1.account_based_expense_line_detail.tax_code_ref.value.should == "3"

    line2 = purchase.line_items[1]
    line2.detail_type.should == "ItemBasedExpenseLineDetail"
    line2.id.should == 2
    line2.amount.should == 1.0
    line2.description.should == "this is item line 1"
    line2.item_based_expense_line_detail.quantity.should == 1
    line2.item_based_expense_line_detail.tax_code_ref.value.should == "5"
    line2.item_based_expense_line_detail.billable_status.should == "NotBillable"
    line2.item_based_expense_line_detail.item_ref.value.should == "3"
    line2.item_based_expense_line_detail.item_ref.name.should == "Test Purchase Item"
    line2.account_based_expense_line_detail.account_ref.value.should == "62"
    line2.account_based_expense_line_detail.account_ref.name.should == "Test Purchase Expense Account"
  end

  it "parse from XML (credit_card)" do
    xml = fixture("purchase_credit_card_response.xml")
    purchase = Quickbooks::Model::Purchase.from_xml(xml)
    purchase.sync_token.should == 0
    purchase.txn_date.to_date.should == Date.civil(2013,1,4)
    purchase.total_amount.should == 0
    purchase.payment_type.should == "CreditCard"

    purchase.account_ref.value.should == "64"
    purchase.account_ref.name.should == "Test Purchase Credit Card Account"
    purchase.entity_ref.value.should == "1"
    purchase.entity_ref.name.should == "Mr V3 Service Customer Jr2"

    purchase.line_items.size.should == 1
    
    line1 = purchase.line_items[0]
    line1.detail_type.should == "AccountBasedExpenseLineDetail"
    line1.id.should == 1
    line1.amount.should == 0
    line1.description.should == "this is description only."
    line1.account_based_expense_line_detail.account_ref.value.should == "60"
    line1.account_based_expense_line_detail.account_ref.name.should == "Advertising"
    line1.account_based_expense_line_detail.billable_status.should == "NotBillable"
    line1.account_based_expense_line_detail.tax_code_ref.value.should == "NON"
  end
end
