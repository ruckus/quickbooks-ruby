describe "Quickbooks::Model::SalesReceipt" do
  it "parse from XML" do
    xml = fixture("sales_receipt.xml")
    sales_receipt = Quickbooks::Model::SalesReceipt.from_xml(xml)
    expect(sales_receipt.id).to eq("2")
    expect(sales_receipt.sync_token).to eq(0)

    expect(sales_receipt.meta_data).not_to be_nil
    expect(sales_receipt.meta_data.create_time).to eq(DateTime.parse("2013-12-10T05:35:42-08:00"))
    expect(sales_receipt.meta_data.last_updated_time).to eq(DateTime.parse("2013-12-10T05:35:42-08:00"))

    expect(sales_receipt.doc_number).to eq("1002")
    expect(sales_receipt.txn_date).to eq(Time.parse("2013-12-10"))

    expect(sales_receipt.line_items.first).not_to be_nil
    expect(sales_receipt.line_items.first.id).to eq("1")
    expect(sales_receipt.line_items.first.line_num).to eq(1)
    expect(sales_receipt.line_items.first.amount).to eq(10.00)
    expect(sales_receipt.line_items.first.detail_type).to eq("SalesItemLineDetail")
    expect(sales_receipt.line_items.first.sales_item_line_detail.item_ref.name).to eq("Sales")
    expect(sales_receipt.line_items.first.sales_item_line_detail.item_ref.value).to eq("1")
    expect(sales_receipt.line_items.first.sales_item_line_detail.unit_price).to eq(10)
    expect(sales_receipt.line_items.first.sales_item_line_detail.quantity).to eq(1)
    expect(sales_receipt.line_items.first.sales_item_line_detail.tax_inclusive_amount).to eq(0.0)

    expect(sales_receipt.line_items[1]).not_to be_nil
    expect(sales_receipt.line_items[1].amount).to eq(10.00)
    expect(sales_receipt.line_items[1].detail_type).to eq("SubTotalLineDetail")

    expect(sales_receipt.line_items.last).not_to be_nil
    expect(sales_receipt.line_items.last.id).to eq("2")
    expect(sales_receipt.line_items.last.line_num).to eq(2)
    expect(sales_receipt.line_items.last.detail_type).to eq("GroupLineDetail")
    expect(sales_receipt.line_items.last.group_line_detail.group_item_ref.name).to eq("More Sales")
    expect(sales_receipt.line_items.last.group_line_detail.group_item_ref.value).to eq("2")

    expect(sales_receipt.line_items.last.group_line_detail.line_items.first).not_to be_nil
    expect(sales_receipt.line_items.last.group_line_detail.line_items.first.id).to eq("3")
    expect(sales_receipt.line_items.last.group_line_detail.line_items.first.amount).to eq(15.00)
    expect(sales_receipt.line_items.last.group_line_detail.line_items.first.detail_type).to eq("SalesItemLineDetail")
    expect(sales_receipt.line_items.last.group_line_detail.line_items.first.sales_item_line_detail.item_ref.name).to eq("Sales")
    expect(sales_receipt.line_items.last.group_line_detail.line_items.first.sales_item_line_detail.item_ref.value).to eq("2")
    expect(sales_receipt.line_items.last.group_line_detail.line_items.first.sales_item_line_detail.unit_price).to eq(100)
    expect(sales_receipt.line_items.last.group_line_detail.line_items.first.sales_item_line_detail.quantity).to eq(1)

    expect(sales_receipt.customer_ref).not_to be_nil
    expect(sales_receipt.customer_ref.name).to eq("Luis Braga")
    expect(sales_receipt.customer_ref.value).to eq("1")

    expect(sales_receipt.deposit_to_account_ref).not_to be_nil
    expect(sales_receipt.deposit_to_account_ref.name).to eq("Cash and cash equivalents")
    expect(sales_receipt.deposit_to_account_ref.value).to eq("28")

    expect(sales_receipt.customer_memo).to eq("memo!")
    expect(sales_receipt.private_note).to eq("private")

    expect(sales_receipt.total).to eq(10.00)

    billing_address = sales_receipt.bill_address
    expect(billing_address).to_not be_nil
    expect(billing_address.id).to eq "6"
    expect(billing_address.line1).to eq "Rebecca Clark"
    expect(billing_address.line2).to eq "Sunset Bakery"
    expect(billing_address.line3).to eq "1040 East Tasman Drive."
    expect(billing_address.line4).to eq "Los Angeles, CA  91123 USA"
    expect(billing_address.lat).to eq "34.1426959"
    expect(billing_address.lon).to eq "-118.1568847"

    shipping_address = sales_receipt.ship_address
    expect(shipping_address).to_not be_nil
    expect(shipping_address.id).to eq "3"
    expect(shipping_address.line1).to eq "1040 East Tasman Drive."
    expect(shipping_address.city).to eq "Los Angeles"
    expect(shipping_address.country).to eq "USA"
    expect(shipping_address.country_sub_division_code).to eq "CA"
    expect(shipping_address.postal_code).to eq "91123"
    expect(shipping_address.lat).to eq "33.739466"
    expect(shipping_address.lon).to eq "-118.0395574"

    ship_from_address = sales_receipt.ship_from_address
    expect(ship_from_address).to_not be_nil
    expect(ship_from_address.id).to eq "5"
    expect(ship_from_address.line1).to eq "1040 East Tasman Drive."
    expect(ship_from_address.city).to eq "Los Angeles"
    expect(ship_from_address.country).to eq "USA"
    expect(ship_from_address.country_sub_division_code).to eq "CA"
    expect(ship_from_address.postal_code).to eq "91123"
    expect(ship_from_address.lat).to eq "33.739466"
    expect(ship_from_address.lon).to eq "-118.0395574"
  end

  it "should initialize line items as empty array" do
     sales_receipt = Quickbooks::Model::SalesReceipt.new
     expect(sales_receipt.line_items).not_to be_nil
     expect(sales_receipt.line_items.length).to eq(0)
  end

  describe "#bill_email" do
    it "sets the billing email address" do
      sales_receipt = Quickbooks::Model::SalesReceipt.new
      sales_receipt.billing_email_address = "test@test.com"
      expect(sales_receipt.bill_email.address).to eq "test@test.com"
    end
    it "sets the billing email address using email= (backward compatibility to v0.4.6)" do
      sales_receipt = Quickbooks::Model::SalesReceipt.new
      sales_receipt.email = "test@test.com"
      expect(sales_receipt.bill_email.address).to eq "test@test.com"
    end
  end

  describe "#auto_doc_number" do
    it_should_behave_like "a model that has auto_doc_number support", 'SalesReceipt'
  end

  describe "#global_tax_calculation" do
    subject { Quickbooks::Model::SalesReceipt.new }
    it_should_behave_like "a model with a valid GlobalTaxCalculation", "TaxInclusive"
    it_should_behave_like "a model with a valid GlobalTaxCalculation", "TaxExcluded"
    it_should_behave_like "a model with a valid GlobalTaxCalculation", "NotApplicable"
    it_should_behave_like "a model with a valid GlobalTaxCalculation", ""
    it_should_behave_like "a model with an invalid GlobalTaxCalculation"
  end
end
