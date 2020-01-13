describe "Quickbooks::Model::RefundReceipt" do
  it "parse from XML" do
    xml = fixture("refund_receipt.xml")
    refund_receipt = Quickbooks::Model::RefundReceipt.from_xml(xml)
    expect(refund_receipt.id).to eq("2")
    expect(refund_receipt.sync_token).to eq(0)

    expect(refund_receipt.meta_data).not_to be_nil
    expect(refund_receipt.meta_data.create_time).to eq(DateTime.parse("2014-04-24T15:15:42-07:00"))
    expect(refund_receipt.meta_data.last_updated_time).to eq(DateTime.parse("2014-04-24T15:15:42-07:00"))

    expect(refund_receipt.custom_fields.size).to eq(1)
    custom_field = refund_receipt.custom_fields.first
    expect(custom_field.name).to eq("Sales Rep")
    expect(custom_field.type).to eq("StringType")
    expect(custom_field.string_value).to eq("2435245")

    expect(refund_receipt.doc_number).to eq("10030")
    expect(refund_receipt.txn_date).to eq(Date.civil(2014, 04, 24))

    expect(refund_receipt.department_ref).not_to be_nil
    expect(refund_receipt.department_ref.name).to eq("Garden Services")
    expect(refund_receipt.department_ref.value).to eq("1")

    expect(refund_receipt.currency_ref).not_to be_nil
    expect(refund_receipt.currency_ref.name).to eq("United States Dollar")
    expect(refund_receipt.currency_ref.value).to eq("USD")

    expect(refund_receipt.private_note).to eq("This is a memo.")

    expect(refund_receipt.line_items.first).not_to be_nil
    expect(refund_receipt.line_items.first.id).to eq("1")
    expect(refund_receipt.line_items.first.line_num).to eq(1)
    expect(refund_receipt.line_items.first.amount).to eq(345.00)
    expect(refund_receipt.line_items.first.detail_type).to eq("SalesItemLineDetail")
    expect(refund_receipt.line_items.first.sales_item_line_detail.item_ref.name).to eq("Deck Lumber")
    expect(refund_receipt.line_items.first.sales_item_line_detail.item_ref.value).to eq("34")
    expect(refund_receipt.line_items.first.sales_item_line_detail.unit_price).to eq(23)
    expect(refund_receipt.line_items.first.sales_item_line_detail.quantity).to eq(15)

    expect(refund_receipt.line_items.last).not_to be_nil
    expect(refund_receipt.line_items.last.amount).to eq(345.00)
    expect(refund_receipt.line_items.last.detail_type).to eq("SubTotalLineDetail")

    expect(refund_receipt.txn_tax_detail.lines.size).to eq(1)
    tax_line = refund_receipt.txn_tax_detail.lines.first
    expect(tax_line.detail_type).to eq("TaxLineDetail")
    expect(tax_line.amount).to eq(22.43)
    expect(tax_line.tax_line_detail.tax_rate_ref.value).to eq("1")
    expect(tax_line.tax_line_detail.percent_based?).to be true
    expect(tax_line.tax_line_detail.tax_percent).to eq(6.5)
    expect(tax_line.tax_line_detail.net_amount_taxable).to eq(345.00)

    expect(refund_receipt.customer_ref).not_to be_nil
    expect(refund_receipt.customer_ref.name).to eq("Candy Shop")
    expect(refund_receipt.customer_ref.value).to eq("64")

    expect(refund_receipt.customer_memo).to eq("memo!")

    expect(refund_receipt.bill_address).not_to be_nil
    expect(refund_receipt.bill_address.id).to eq("413")
    expect(refund_receipt.bill_address.line1).to eq("Mr. Adam Bradley")
    expect(refund_receipt.bill_address.line2).to eq("Adam's Candy Shop")
    expect(refund_receipt.bill_address.line3).to eq("1528 Kitty Bang Bang St.")
    expect(refund_receipt.bill_address.line4).to eq("Fudge, CA 94555")
    expect(refund_receipt.bill_address.line5).to be_nil
    expect(refund_receipt.bill_address.lat).to eq("37.5677679")
    expect(refund_receipt.bill_address.lon).to eq("-122.0522177")

    expect(refund_receipt.ship_address).not_to be_nil
    expect(refund_receipt.ship_address.id).to eq("414")
    expect(refund_receipt.ship_address.line1).to eq("Mr. Adam Bradley")
    expect(refund_receipt.ship_address.line2).to eq("Adam's Candy Shop")
    expect(refund_receipt.ship_address.line3).to eq("Adam's Candy Shop")
    expect(refund_receipt.ship_address.line4).to eq("Adam Bradley")
    expect(refund_receipt.ship_address.line5).to eq("1528 Kitty Bang Bang St.\r Fudge, CA 94555")
    expect(refund_receipt.ship_address.lat).to eq("37.5677679")
    expect(refund_receipt.ship_address.lon).to eq("-122.0522177")

    expect(refund_receipt.class_ref).not_to be_nil
    expect(refund_receipt.class_ref.name).to eq("Landscaping")
    expect(refund_receipt.class_ref.value).to eq("100000000000368490")

    expect(refund_receipt.total).to eq(337.93)
    expect(refund_receipt.apply_tax_after_discount?).to eq(false)
    expect(refund_receipt.print_status).to eq("NeedToPrint")

    expect(refund_receipt.bill_email).not_to be_nil
    expect(refund_receipt.bill_email.address).to eq("adam@gmail.com")

    expect(refund_receipt.balance).to eq(0)

    expect(refund_receipt.payment_method_ref).not_to be_nil
    expect(refund_receipt.payment_method_ref.name).to eq("Check")
    expect(refund_receipt.payment_method_ref.value).to eq("9")

    expect(refund_receipt.payment_ref_number).to eq("To Print")

    expect(refund_receipt.deposit_to_account_ref).not_to be_nil
    expect(refund_receipt.deposit_to_account_ref.name).to eq("Checking")
    expect(refund_receipt.deposit_to_account_ref.value).to eq("40")
  end

  it "should initialize line items as empty array" do
     refund_receipt = Quickbooks::Model::SalesReceipt.new
     expect(refund_receipt.line_items).not_to be_nil
     expect(refund_receipt.line_items.length).to eq(0)
  end

  describe "#auto_doc_number" do

    it "turned on should set the AutoDocNumber tag" do
      refund_receipt = Quickbooks::Model::RefundReceipt.new
      refund_receipt.auto_doc_number!
      expect(refund_receipt.to_xml.to_s).to match(/AutoDocNumber/)
    end

    it "turned on then doc_number should not be specified" do
      refund_receipt = Quickbooks::Model::RefundReceipt.new
      refund_receipt.doc_number = 'AUTO'
      refund_receipt.auto_doc_number!
      refund_receipt.valid?
      expect(refund_receipt.valid?).to eq(false)
      expect(refund_receipt.errors.keys.include?(:doc_number)).to be true
    end

    it "turned off then doc_number can be specified" do
      refund_receipt = Quickbooks::Model::RefundReceipt.new
      refund_receipt.doc_number = 'AUTO'
      refund_receipt.valid?
      expect(refund_receipt.errors.keys.include?(:doc_number)).to be false
    end
  end

  describe "#global_tax_calculation" do
    subject { Quickbooks::Model::RefundReceipt.new }
    it_should_behave_like "a model with a valid GlobalTaxCalculation", "TaxInclusive"
    it_should_behave_like "a model with a valid GlobalTaxCalculation", "TaxExcluded"
    it_should_behave_like "a model with a valid GlobalTaxCalculation", "NotApplicable"
    it_should_behave_like "a model with a valid GlobalTaxCalculation", ""
    it_should_behave_like "a model with an invalid GlobalTaxCalculation"
  end
end
