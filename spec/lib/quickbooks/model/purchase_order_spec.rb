describe "Quickbooks::Model::PurchaseOrder" do

  it "parse from XML" do
    xml = fixture("purchase_order.xml")
    purchase_order = Quickbooks::Model::PurchaseOrder.from_xml(xml)
    purchase_order.sync_token.should == 0
    purchase_order.id.should == 813
    purchase_order.txn_date.to_date.should == Date.civil(2013,7,19)
    purchase_order.total_amount.should == 72.0

    purchase_order.vendor_ref.value.should == "24"
    purchase_order.vendor_ref.name.should == "Brown Equipment Rental"
    purchase_order.ap_account_ref.value.should == "38"
    purchase_order.ap_account_ref.name.should == "Accounts Payable"

    purchase_order.vendor_address.id.should == 339
    purchase_order.vendor_address.line1.should == "Sylvester Brown"
    purchase_order.vendor_address.line2.should == "33 Old Bayshore Rd"
    purchase_order.vendor_address.line3.should == "Bayshore, CA  94326"

    purchase_order.ship_address.id.should == 340
    purchase_order.ship_address.line1.should == "Larry's Landscaping & Garden Supply"
    purchase_order.ship_address.line2.should == "1045 Main Street"
    purchase_order.ship_address.line3.should == "Bayshore, CA 94326"
    purchase_order.ship_address.line4.should == "(415)  555-4567"

    purchase_order.line_items.size.should == 1
    
    line1 = purchase_order.line_items[0]
    line1.detail_type.should == "ItemBasedExpenseLineDetail"
    line1.id.should == 1
    line1.amount.should == 72.0
    line1.description.should == "hose"
    line1.item_based_expense_line_detail.item_ref.value.should == "31"
    line1.item_based_expense_line_detail.item_ref.name.should == "Irrigation Hose"
    line1.item_based_expense_line_detail.class_ref.value.should == "100000000000128319"
    line1.item_based_expense_line_detail.class_ref.name.should == "Landscaping"
    line1.item_based_expense_line_detail.unit_price.should == 72
    line1.item_based_expense_line_detail.quantity.should == 1
    line1.item_based_expense_line_detail.billable_status.should == "NotBillable"
    line1.item_based_expense_line_detail.tax_code_ref.value.should == "NON"
    line1.account_based_expense_line_detail.account_ref.value.should == "139"
    line1.account_based_expense_line_detail.account_ref.name.should == "Inventory Asset-1"
  end

  describe "#global_tax_calculation" do
    subject { Quickbooks::Model::PurchaseOrder.new }
    it_should_behave_like "a model with a valid GlobalTaxCalculation", "TaxInclusive"
    it_should_behave_like "a model with a valid GlobalTaxCalculation", "TaxExcluded"
    it_should_behave_like "a model with a valid GlobalTaxCalculation", "NotApplicable"
    it_should_behave_like "a model with a valid GlobalTaxCalculation", ""
    it_should_behave_like "a model with an invalid GlobalTaxCalculation"
  end

end
