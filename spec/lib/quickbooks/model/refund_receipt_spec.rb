describe "Quickbooks::Model::RefundReceipt" do
  it "parse from XML" do
    xml = fixture("refund_receipt.xml")
    refund_receipt = Quickbooks::Model::RefundReceipt.from_xml(xml)
    refund_receipt.id.should == 2
    refund_receipt.sync_token.should == 0

    refund_receipt.meta_data.should_not be_nil
    refund_receipt.meta_data.create_time.should == DateTime.parse("2014-04-24T15:15:42-07:00")
    refund_receipt.meta_data.last_updated_time.should == DateTime.parse("2014-04-24T15:15:42-07:00")

    refund_receipt.custom_fields.size.should == 1
    custom_field = refund_receipt.custom_fields.first
    custom_field.name.should == "Sales Rep"
    custom_field.type.should == "StringType"
    custom_field.string_value.should == "2435245"

    refund_receipt.doc_number.should == "10030"
    refund_receipt.txn_date.should == Date.civil(2014, 04, 24)

    refund_receipt.department_ref.should_not be_nil
    refund_receipt.department_ref.name.should == "Garden Services"
    refund_receipt.department_ref.value.should == "1"

    refund_receipt.currency_ref.should_not be_nil
    refund_receipt.currency_ref.name.should == "United States Dollar"
    refund_receipt.currency_ref.value.should == "USD"

    refund_receipt.private_note.should == "This is a memo."

    refund_receipt.line_items.first.should_not be_nil
    refund_receipt.line_items.first.id.should == 1
    refund_receipt.line_items.first.line_num.should == 1
    refund_receipt.line_items.first.amount.should == 345.00
    refund_receipt.line_items.first.detail_type.should == "SalesItemLineDetail"
    refund_receipt.line_items.first.sales_item_line_detail.item_ref.name.should == "Deck Lumber"
    refund_receipt.line_items.first.sales_item_line_detail.item_ref.value.should == "34"
    refund_receipt.line_items.first.sales_item_line_detail.unit_price.should == 23
    refund_receipt.line_items.first.sales_item_line_detail.quantity.should == 15

    refund_receipt.line_items.last.should_not be_nil
    refund_receipt.line_items.last.amount.should == 345.00
    refund_receipt.line_items.last.detail_type.should == "SubTotalLineDetail"

    refund_receipt.txn_tax_detail.lines.size.should == 1
    tax_line = refund_receipt.txn_tax_detail.lines.first
    tax_line.detail_type.should == "TaxLineDetail"
    tax_line.amount.should == 22.43
    tax_line.tax_line_detail.tax_rate_ref.value.should == "1"
    tax_line.tax_line_detail.percent_based?.should be_true
    tax_line.tax_line_detail.tax_percent.should == 6.5
    tax_line.tax_line_detail.net_amount_taxable.should == 345.00

    refund_receipt.customer_ref.should_not be_nil
    refund_receipt.customer_ref.name.should == "Candy Shop"
    refund_receipt.customer_ref.value.should == "64"

    refund_receipt.customer_memo.should == "memo!"

    refund_receipt.bill_address.should_not be_nil
    refund_receipt.bill_address.id.should == 413
    refund_receipt.bill_address.line1.should == "Mr. Adam Bradley"
    refund_receipt.bill_address.line2.should == "Adam's Candy Shop"
    refund_receipt.bill_address.line3.should == "1528 Kitty Bang Bang St."
    refund_receipt.bill_address.line4.should == "Fudge, CA 94555"
    refund_receipt.bill_address.line5.should be_nil
    refund_receipt.bill_address.lat.should == "37.5677679"
    refund_receipt.bill_address.lon.should == "-122.0522177"

    refund_receipt.ship_address.should_not be_nil
    refund_receipt.ship_address.id.should == 414
    refund_receipt.ship_address.line1.should == "Mr. Adam Bradley"
    refund_receipt.ship_address.line2.should == "Adam's Candy Shop"
    refund_receipt.ship_address.line3.should == "Adam's Candy Shop"
    refund_receipt.ship_address.line4.should == "Adam Bradley"
    refund_receipt.ship_address.line5.should == "1528 Kitty Bang Bang St.\r Fudge, CA 94555"
    refund_receipt.ship_address.lat.should == "37.5677679"
    refund_receipt.ship_address.lon.should == "-122.0522177"

    refund_receipt.class_ref.should_not be_nil
    refund_receipt.class_ref.name.should == "Landscaping"
    refund_receipt.class_ref.value.should == "100000000000368490"

    refund_receipt.total.should == 337.93
    refund_receipt.apply_tax_after_discount?.should == false
    refund_receipt.print_status.should == "NeedToPrint"

    refund_receipt.bill_email.should_not be_nil
    refund_receipt.bill_email.address.should == "adam@gmail.com"

    refund_receipt.balance.should == 0

    refund_receipt.payment_method_ref.should_not be_nil
    refund_receipt.payment_method_ref.name.should == "Check"
    refund_receipt.payment_method_ref.value.should == "9"

    refund_receipt.payment_ref_number.should == "To Print"

    refund_receipt.deposit_to_account_ref.should_not be_nil
    refund_receipt.deposit_to_account_ref.name.should == "Checking"
    refund_receipt.deposit_to_account_ref.value.should == "40"
  end

  it "should initialize line items as empty array" do
     refund_receipt = Quickbooks::Model::SalesReceipt.new
     refund_receipt.line_items.should_not be_nil
     refund_receipt.line_items.length.should == 0
  end

  describe "#auto_doc_number" do

    it "turned on should set the AutoDocNumber tag" do
      refund_receipt = Quickbooks::Model::RefundReceipt.new
      refund_receipt.auto_doc_number!
      refund_receipt.to_xml.to_s.should =~ /AutoDocNumber/
    end

    it "turned on then doc_number should not be specified" do
      refund_receipt = Quickbooks::Model::RefundReceipt.new
      refund_receipt.doc_number = 'AUTO'
      refund_receipt.auto_doc_number!
      refund_receipt.valid?
      refund_receipt.valid?.should == false
      refund_receipt.errors.keys.include?(:doc_number).should be_true
    end

    it "turned off then doc_number can be specified" do
      refund_receipt = Quickbooks::Model::RefundReceipt.new
      refund_receipt.doc_number = 'AUTO'
      refund_receipt.valid?
      refund_receipt.errors.keys.include?(:doc_number).should be_false
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
