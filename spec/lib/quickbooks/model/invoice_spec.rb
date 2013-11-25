describe "Quickbooks::Model::Invoice" do

  it "parse from XML" do
    xml = fixture("invoice.xml")
    invoice = Quickbooks::Model::Invoice.from_xml(xml)
    invoice.sync_token.should == 2

    invoice.meta_data.should_not be_nil
    invoice.doc_number.should == "1001"
    invoice.txn_date.to_date.should == Date.civil(2013, 11, 15)
    invoice.private_note.should == "Statement Memo"
    invoice.line_items.should_not be_nil
    invoice.line_items.length.should == 2

    line_item1 = invoice.line_items[0]
    line_item1.id.should == 1
    line_item1.line_num.should == 1
    line_item1.description.should == 'Plush Baby Doll'
    line_item1.amount.should == 50.00
    line_item1.sales_item?.should == true
    line_item1.sales_line_item_detail.should_not be_nil
    line_item1.sales_line_item_detail.item_ref.should == 1
    line_item1.sales_line_item_detail.unit_price.should == 50
    line_item1.sales_line_item_detail.quantity.should == 1
    line_item1.sales_line_item_detail.tax_code_ref.should == 'NON'

    line_item2 = invoice.line_items[1]
    line_item2.sub_total_item?.should == true

    invoice.customer_ref.value.should == "2"
    invoice.customer_ref.name.should == "Sunset Bakery"
    invoice.customer_memo.should == "Message to Customer"

    billing_address = invoice.billing_address
    billing_address.should_not be_nil
    billing_address.id.should == 6
    billing_address.line1.should == "Rebecca Clark"
    billing_address.line2.should == "Sunset Bakery"
    billing_address.line3.should == "1040 East Tasman Drive."
    billing_address.line4.should == "Los Angeles, CA  91123 USA"
    billing_address.lat.should == 34.1426959
    billing_address.lon.should == -118.1568847

    shipping_address = invoice.shipping_address
    shipping_address.should_not be_nil
    shipping_address.id.should == 3
    shipping_address.line1.should == "1040 East Tasman Drive."
    shipping_address.city.should == "Los Angeles"
    shipping_address.country.should == "USA"
    shipping_address.country_sub_division_code.should == "CA"
    shipping_address.postal_code.should == "91123"
    shipping_address.lat.should == 33.739466
    shipping_address.lon.should == -118.0395574

    invoice.sales_term_ref.should == 2
    invoice.due_date.to_date.should == Date.civil(2013, 11, 30)
    invoice.total_amount.should == 50.00
    invoice.apply_tax_after_discount?.should == false
    invoice.print_status.should == 'NotSet'
    invoice.email_status.should == 'NotSet'
    invoice.balance.should == 50
    invoice.deposit.should == 0
    invoice.allow_ipn_payment?.should == true
    invoice.allow_online_payment?.should == false
    invoice.allow_online_credit_card_payment?.should == true
    invoice.allow_online_ach_payment?.should == false
  end

  it "should require line items for create / update" do
    invoice = Quickbooks::Model::Invoice.new
    invoice.valid?.should == false
    invoice.errors.keys.include?(:line_items).should == true
  end

  it "should require customer_ref for create / update" do
    invoice = Quickbooks::Model::Invoice.new
    invoice.valid?.should == false
    invoice.errors.keys.include?(:customer_ref).should == true
  end

  it "is valid with line_items and customer_ref" do
    invoice = Quickbooks::Model::Invoice.new
    invoice.customer_id = 2
    invoice.line_items << Quickbooks::Model::InvoiceLineItem.new

    invoice.valid?.should == true
  end

  it "is not valid when EmailStatus is set but there is no billing email" do
    invoice = Quickbooks::Model::Invoice.new
    invoice.wants_billing_email_sent!
    invoice.valid?.should == false
    invoice.errors.keys.include?(:bill_email).should == true

    # now specify an email address it will be valid for this attribute
    invoice.billing_email_address = "foo@example.com"
    invoice.valid?.should == false
    invoice.errors.keys.include?(:bill_email).should == false
  end
end
