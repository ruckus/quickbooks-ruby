require 'nokogiri'

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
    invoice.currency_ref.to_s.should == 'USD'
    invoice.currency_ref.name.should == 'United States Dollar'
    invoice.exchange_rate.should == 1.5

    line_item1 = invoice.line_items[0]
    line_item1.id.should == "1"
    line_item1.line_num.should == 1
    line_item1.description.should == 'Plush Baby Doll'
    line_item1.amount.should == 198.99
    line_item1.sales_item?.should == true
    line_item1.sales_line_item_detail.should_not be_nil
    line_item1.sales_line_item_detail.item_ref.to_i.should == 1
    line_item1.sales_line_item_detail.unit_price.should == 198.99
    line_item1.sales_line_item_detail.quantity.should == 1
    line_item1.sales_line_item_detail.tax_code_ref.to_s.should == 'NON'

    line_item2 = invoice.line_items[1]
    line_item2.sub_total_item?.should == true

    invoice.customer_ref.value.should == "2"
    invoice.customer_ref.name.should == "Sunset Bakery"
    invoice.customer_memo.should == "Message to Customer"

    billing_address = invoice.billing_address
    billing_address.should_not be_nil
    billing_address.id.should == "6"
    billing_address.line1.should == "Rebecca Clark"
    billing_address.line2.should == "Sunset Bakery"
    billing_address.line3.should == "1040 East Tasman Drive."
    billing_address.line4.should == "Los Angeles, CA  91123 USA"
    billing_address.lat.should == "34.1426959"
    billing_address.lon.should == "-118.1568847"

    shipping_address = invoice.shipping_address
    shipping_address.should_not be_nil
    shipping_address.id.should == "3"
    shipping_address.line1.should == "1040 East Tasman Drive."
    shipping_address.city.should == "Los Angeles"
    shipping_address.country.should == "USA"
    shipping_address.country_sub_division_code.should == "CA"
    shipping_address.postal_code.should == "91123"
    shipping_address.lat.should == "33.739466"
    shipping_address.lon.should == "-118.0395574"

    tax_detail = invoice.txn_tax_detail
    tax_detail.total_tax.should eq(2.85)
    first_tax_line, second_tax_line = tax_detail.lines

    first_tax_line.amount.should eq(0)
    first_tax_line.detail_type.should eq("TaxLineDetail")
    first_tax_line.tax_line_detail.tax_rate_ref.value.should eq("4")
    first_tax_line.tax_line_detail.percent_based?.should be_true
    first_tax_line.tax_line_detail.tax_percent.should eq(0.0)
    first_tax_line.tax_line_detail.net_amount_taxable.should eq(4.0)

    second_tax_line.amount.should eq(2.85)
    second_tax_line.detail_type.should eq("TaxLineDetail")
    second_tax_line.tax_line_detail.tax_rate_ref.value.should eq("20")
    second_tax_line.tax_line_detail.percent_based?.should be_true
    second_tax_line.tax_line_detail.tax_percent.should eq(10.0)
    second_tax_line.tax_line_detail.net_amount_taxable.should eq(28.5)

    invoice.sales_term_ref.to_i.should == 2
    invoice.due_date.to_date.should == Date.civil(2013, 11, 30)
    invoice.total_amount.should == 50.00
    invoice.home_total_amount.should == 75.00
    invoice.apply_tax_after_discount?.should == false
    invoice.print_status.should == 'NotSet'
    invoice.email_status.should == 'NotSet'
    invoice.balance.should == 50
    invoice.home_balance.should == 75
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

  it "can load a description-only line item detail from XML" do
    input_xml = fixture("invoice_line_item_description_only.xml")
    invoice = Quickbooks::Model::Invoice.from_xml(input_xml)
    desc_line = invoice.line_items.detect { |a| a.description_only? }

    desc_line.should_not be_nil
    desc_line.description.should == 'Just a Description'
  end

  it "can create a description-only line item from building" do
    invoice = Quickbooks::Model::Invoice.new

    invoice.customer_id = 1
    invoice.txn_date = Date.civil(2018, 1, 20)

    line_item = Quickbooks::Model::InvoiceLineItem.new
    line_item.amount = 50
    line_item.description = "Plush Baby Doll"
    line_item.description_only!
    invoice.line_items << line_item

    xml = invoice.to_xml
    xml.should_not be_nil
  end


  describe "#auto_doc_number" do
    it_should_behave_like "a model that has auto_doc_number support", 'Invoice'
  end

  it "can properly convert to/from BigDecimal" do
    input_xml = fixture("invoice.xml")
    invoice = Quickbooks::Model::Invoice.from_xml(input_xml)
    line1 = invoice.line_items.first
    line1.should_not be_nil
    line1.amount.should == 198.99
    line1.amount.class.should == BigDecimal

    xml = Nokogiri(invoice.to_xml.to_s)
    node = xml.xpath("//Invoice/Line/Amount")[0]
    node.should_not be_nil
    node.content.should == "198.99"
  end

  it "can set the currency" do
    invoice = Quickbooks::Model::Invoice.new
    invoice.currency_id = 'CAD'
    invoice.currency_ref.name = 'Canadian Dollar'
    invoice.to_xml.to_s.should match /CurrencyRef name.+?Canadian Dollar.+?>CAD/
  end

  describe "#global_tax_calculation" do
    subject { Quickbooks::Model::Invoice.new }
    it_should_behave_like "a model with a valid GlobalTaxCalculation", "TaxInclusive"
    it_should_behave_like "a model with a valid GlobalTaxCalculation", "TaxExcluded"
    it_should_behave_like "a model with a valid GlobalTaxCalculation", "NotApplicable"
    it_should_behave_like "a model with a valid GlobalTaxCalculation", ""
    it_should_behave_like "a model with an invalid GlobalTaxCalculation"
  end

end
