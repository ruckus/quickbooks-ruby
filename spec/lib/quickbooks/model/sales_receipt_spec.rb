describe "Quickbooks::Model::SalesReceipt" do
  it "parse from XML" do
    xml = fixture("sales_receipt.xml")
    sales_receipt = Quickbooks::Model::SalesReceipt.from_xml(xml)
    sales_receipt.id.should == "2"
    sales_receipt.sync_token.should == 0

    sales_receipt.meta_data.should_not be_nil
    sales_receipt.meta_data.create_time.should == DateTime.parse("2013-12-10T05:35:42-08:00")
    sales_receipt.meta_data.last_updated_time.should == DateTime.parse("2013-12-10T05:35:42-08:00")

    sales_receipt.doc_number.should == "1002"
    sales_receipt.txn_date.should == Time.parse("2013-12-10")

    sales_receipt.line_items.first.should_not be_nil
    sales_receipt.line_items.first.id.should == "1"
    sales_receipt.line_items.first.line_num.should == 1
    sales_receipt.line_items.first.amount.should == 10.00
    sales_receipt.line_items.first.detail_type.should == "SalesItemLineDetail"
    sales_receipt.line_items.first.sales_item_line_detail.item_ref.name.should == "Sales"
    sales_receipt.line_items.first.sales_item_line_detail.item_ref.value.should == "1"
    sales_receipt.line_items.first.sales_item_line_detail.unit_price.should == 10
    sales_receipt.line_items.first.sales_item_line_detail.quantity.should == 1

    sales_receipt.line_items[1].should_not be_nil
    sales_receipt.line_items[1].amount.should == 10.00
    sales_receipt.line_items[1].detail_type.should == "SubTotalLineDetail"

    sales_receipt.line_items.last.should_not be_nil
    sales_receipt.line_items.last.id.should == "2"
    sales_receipt.line_items.last.line_num.should == 2
    sales_receipt.line_items.last.detail_type.should == "GroupLineDetail"
    sales_receipt.line_items.last.group_line_detail.group_item_ref.name.should == "More Sales"
    sales_receipt.line_items.last.group_line_detail.group_item_ref.value.should == "2"

    sales_receipt.line_items.last.group_line_detail.line_items.first.should_not be_nil
    sales_receipt.line_items.last.group_line_detail.line_items.first.id.should == "3"
    sales_receipt.line_items.last.group_line_detail.line_items.first.amount.should == 15.00
    sales_receipt.line_items.last.group_line_detail.line_items.first.detail_type.should == "SalesItemLineDetail"
    sales_receipt.line_items.last.group_line_detail.line_items.first.sales_item_line_detail.item_ref.name.should == "Sales"
    sales_receipt.line_items.last.group_line_detail.line_items.first.sales_item_line_detail.item_ref.value.should == "2"
    sales_receipt.line_items.last.group_line_detail.line_items.first.sales_item_line_detail.unit_price.should == 100
    sales_receipt.line_items.last.group_line_detail.line_items.first.sales_item_line_detail.quantity.should == 1

    sales_receipt.customer_ref.should_not be_nil
    sales_receipt.customer_ref.name.should == "Luis Braga"
    sales_receipt.customer_ref.value.should == "1"

    sales_receipt.deposit_to_account_ref.should_not be_nil
    sales_receipt.deposit_to_account_ref.name.should == "Cash and cash equivalents"
    sales_receipt.deposit_to_account_ref.value.should == "28"

    sales_receipt.customer_memo.should == "memo!"
    sales_receipt.private_note.should == "private"

    sales_receipt.total.should == 10.00
  end

  it "should initialize line items as empty array" do
     sales_receipt = Quickbooks::Model::SalesReceipt.new
     sales_receipt.line_items.should_not be_nil
     sales_receipt.line_items.length.should == 0
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
