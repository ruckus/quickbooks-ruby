require 'nokogiri'

describe "Quickbooks::Model::Invoice" do

  it "parse from XML" do
    xml = fixture("invoice.xml")
    invoice = Quickbooks::Model::Invoice.from_xml(xml)
    expect(invoice.sync_token).to eq 2

    expect(invoice.meta_data).to_not be_nil
    expect(invoice.doc_number).to eq "1001"
    expect(invoice.txn_date.to_date).to eq Date.civil(2013, 11, 15)
    expect(invoice.private_note).to eq "Statement Memo"
    expect(invoice.line_items).to_not be_nil
    expect(invoice.line_items.length).to eq 2
    expect(invoice.currency_ref.to_s).to eq 'USD'
    expect(invoice.currency_ref.name).to eq 'United States Dollar'
    expect(invoice.exchange_rate).to eq 1.5

    line_item1 = invoice.line_items[0]
    expect(line_item1.id).to eq "1"
    expect(line_item1.line_num).to eq 1
    expect(line_item1.description).to eq 'Plush Baby Doll'
    expect(line_item1.amount).to eq 198.99
    expect(line_item1.sales_item?).to be true
    expect(line_item1.sales_line_item_detail).to_not be_nil
    expect(line_item1.sales_line_item_detail.item_ref.to_i).to eq 1
    expect(line_item1.sales_line_item_detail.unit_price).to eq 198.99
    expect(line_item1.sales_line_item_detail.quantity).to eq 1
    expect(line_item1.sales_line_item_detail.tax_code_ref.to_s).to eq 'NON'

    line_item2 = invoice.line_items[1]
    expect(line_item2.sub_total_item?).to be true

    expect(invoice.customer_ref.value).to eq "2"
    expect(invoice.customer_ref.name).to eq "Sunset Bakery"
    expect(invoice.customer_memo).to eq "Message to Customer"

    billing_address = invoice.billing_address
    expect(billing_address).to_not be_nil
    expect(billing_address.id).to eq "6"
    expect(billing_address.line1).to eq "Rebecca Clark"
    expect(billing_address.line2).to eq "Sunset Bakery"
    expect(billing_address.line3).to eq "1040 East Tasman Drive."
    expect(billing_address.line4).to eq "Los Angeles, CA  91123 USA"
    expect(billing_address.lat).to eq "34.1426959"
    expect(billing_address.lon).to eq "-118.1568847"

    shipping_address = invoice.shipping_address
    expect(shipping_address).to_not be_nil
    expect(shipping_address.id).to eq "3"
    expect(shipping_address.line1).to eq "1040 East Tasman Drive."
    expect(shipping_address.city).to eq "Los Angeles"
    expect(shipping_address.country).to eq "USA"
    expect(shipping_address.country_sub_division_code).to eq "CA"
    expect(shipping_address.postal_code).to eq "91123"
    expect(shipping_address.lat).to eq "33.739466"
    expect(shipping_address.lon).to eq "-118.0395574"

    tax_detail = invoice.txn_tax_detail
    expect(tax_detail.total_tax).to eq(2.85)
    first_tax_line, second_tax_line = tax_detail.lines

    expect(first_tax_line.amount).to eq(0)
    expect(first_tax_line.detail_type).to eq("TaxLineDetail")
    expect(first_tax_line.tax_line_detail.tax_rate_ref.value).to eq("4")
    expect(first_tax_line.tax_line_detail.percent_based?).to be true
    expect(first_tax_line.tax_line_detail.tax_percent).to eq(0.0)
    expect(first_tax_line.tax_line_detail.net_amount_taxable).to eq(4.0)

    expect(second_tax_line.amount).to eq(2.85)
    expect(second_tax_line.detail_type).to eq("TaxLineDetail")
    expect(second_tax_line.tax_line_detail.tax_rate_ref.value).to eq("20")
    expect(second_tax_line.tax_line_detail.percent_based?).to be true
    expect(second_tax_line.tax_line_detail.tax_percent).to eq(10.0)
    expect(second_tax_line.tax_line_detail.net_amount_taxable).to eq(28.5)

    expect(invoice.sales_term_ref.to_i).to eq 2
    expect(invoice.due_date.to_date).to eq Date.civil(2013, 11, 30)
    expect(invoice.total_amount).to eq 50.00
    expect(invoice.home_total_amount).to eq 75.00
    expect(invoice.apply_tax_after_discount?).to be false
    expect(invoice.print_status).to eq 'NotSet'
    expect(invoice.email_status).to eq 'NotSet'
    expect(invoice.balance).to eq 50
    expect(invoice.home_balance).to eq 75
    expect(invoice.deposit).to eq 0
    expect(invoice.allow_ipn_payment?).to be true
    expect(invoice.allow_online_payment?).to be false
    expect(invoice.allow_online_credit_card_payment?).to be true
    expect(invoice.allow_online_ach_payment?).to be false
  end

  it "should require line items for create / update" do
    invoice = Quickbooks::Model::Invoice.new
    expect(invoice.valid?).to be false
    expect(invoice.errors.keys.include?(:line_items)).to be true
  end

  it "should require customer_ref for create / update" do
    invoice = Quickbooks::Model::Invoice.new
    expect(invoice.valid?).to be false
    expect(invoice.errors.keys.include?(:customer_ref)).to be true
  end

  it "is valid with line_items and customer_ref" do
    invoice = Quickbooks::Model::Invoice.new
    invoice.customer_id = 2
    invoice.line_items << Quickbooks::Model::InvoiceLineItem.new

    expect(invoice.valid?).to be true
  end

  it "is not valid when EmailStatus is set but there is no billing email" do
    invoice = Quickbooks::Model::Invoice.new
    invoice.wants_billing_email_sent!
    expect(invoice.valid?).to be false
    expect(invoice.errors.keys.include?(:bill_email)).to be true

    # now specify an email address it will be valid for this attribute
    invoice.billing_email_address = "foo@example.com"
    expect(invoice.valid?).to be false
    expect(invoice.errors.keys.include?(:bill_email)).to be false
  end

  it "can load a description-only line item detail from XML" do
    input_xml = fixture("invoice_line_item_description_only.xml")
    invoice = Quickbooks::Model::Invoice.from_xml(input_xml)
    desc_line = invoice.line_items.detect { |a| a.description_only? }

    expect(desc_line).to_not be_nil
    expect(desc_line.description).to eq 'Just a Description'
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
    expect(xml).to_not be_nil
  end


  describe "#auto_doc_number" do
    it_should_behave_like "a model that has auto_doc_number support", 'Invoice'
  end

  it "can properly convert to/from BigDecimal" do
    input_xml = fixture("invoice.xml")
    invoice = Quickbooks::Model::Invoice.from_xml(input_xml)
    line1 = invoice.line_items.first
    expect(line1).to_not be_nil
    expect(line1.amount).to eq 198.99
    expect(line1.amount.class).to eq BigDecimal

    xml = Nokogiri(invoice.to_xml.to_s)
    node = xml.xpath("//Invoice/Line/Amount")[0]
    expect(node).to_not be_nil
    expect(node.content).to eq "198.99"
  end

  it "can set the currency" do
    invoice = Quickbooks::Model::Invoice.new
    invoice.currency_id = 'CAD'
    invoice.currency_ref.name = 'Canadian Dollar'
    expect(invoice.to_xml.to_s).to match /CurrencyRef name.+?Canadian Dollar.+?>CAD/
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
