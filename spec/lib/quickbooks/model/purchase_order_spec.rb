describe "Quickbooks::Model::PurchaseOrder" do

  it "parse from XML" do
    xml = fixture("purchase_order.xml")
    purchase_order = Quickbooks::Model::PurchaseOrder.from_xml(xml)
    expect(purchase_order.sync_token).to eq(0)
    expect(purchase_order.id).to eq("813")
    expect(purchase_order.txn_date.to_date).to eq(Date.civil(2013,7,19))
    expect(purchase_order.total_amount).to eq(72.0)

    expect(purchase_order.vendor_ref.value).to eq("24")
    expect(purchase_order.vendor_ref.name).to eq("Brown Equipment Rental")
    expect(purchase_order.ap_account_ref.value).to eq("38")
    expect(purchase_order.ap_account_ref.name).to eq("Accounts Payable")

    expect(purchase_order.vendor_address.id).to eq("339")
    expect(purchase_order.vendor_address.line1).to eq("Sylvester Brown")
    expect(purchase_order.vendor_address.line2).to eq("33 Old Bayshore Rd")
    expect(purchase_order.vendor_address.line3).to eq("Bayshore, CA  94326")

    expect(purchase_order.ship_address.id).to eq("340")
    expect(purchase_order.ship_address.line1).to eq("Larry's Landscaping & Garden Supply")
    expect(purchase_order.ship_address.line2).to eq("1045 Main Street")
    expect(purchase_order.ship_address.line3).to eq("Bayshore, CA 94326")
    expect(purchase_order.ship_address.line4).to eq("(415)  555-4567")

    expect(purchase_order.line_items.size).to eq(1)

    line1 = purchase_order.line_items[0]
    expect(line1.detail_type).to eq("ItemBasedExpenseLineDetail")
    expect(line1.id).to eq("1")
    expect(line1.amount).to eq(72.0)
    expect(line1.description).to eq("hose")
    expect(line1.item_based_expense_line_detail.item_ref.value).to eq("31")
    expect(line1.item_based_expense_line_detail.item_ref.name).to eq("Irrigation Hose")
    expect(line1.item_based_expense_line_detail.class_ref.value).to eq("100000000000128319")
    expect(line1.item_based_expense_line_detail.class_ref.name).to eq("Landscaping")
    expect(line1.item_based_expense_line_detail.unit_price).to eq(72)
    expect(line1.item_based_expense_line_detail.quantity).to eq(1)
    expect(line1.item_based_expense_line_detail.billable_status).to eq("NotBillable")
    expect(line1.item_based_expense_line_detail.tax_code_ref.value).to eq("NON")
    expect(line1.account_based_expense_line_detail.account_ref.value).to eq("139")
    expect(line1.account_based_expense_line_detail.account_ref.name).to eq("Inventory Asset-1")
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
