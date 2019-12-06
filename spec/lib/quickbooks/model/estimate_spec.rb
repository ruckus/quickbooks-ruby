require 'nokogiri'

describe "Quickbooks::Model::Estimate" do

  it "parse from XML" do
    xml = fixture("estimate.xml")
    estimate = Quickbooks::Model::Estimate.from_xml(xml)
    expect(estimate.sync_token).to eq 0
    expect(estimate.id).to eq "12"

    expect(estimate.meta_data).to_not be_nil
    expect(estimate.doc_number).to eq "3BcMMoa4YQBuUbJucPeR"
    expect(estimate.txn_date.to_date).to eq Date.civil(2012,4,20)
    expect(estimate.custom_fields.length).to eq 3

    expect(estimate.line_items).to_not be_nil
    expect(estimate.line_items.length).to eq 3

    line_item1 = estimate.line_items[0]
    expect(line_item1.id).to eq "1"
    expect(line_item1.line_num).to eq 1
    expect(line_item1.description).to eq 'dsfafdfasdfdsfasdfadsfasdfsad'
    expect(line_item1.amount).to eq 20.0
    expect(line_item1.sales_item?).to be true
    expect(line_item1.sales_line_item_detail).to_not be_nil
    expect(line_item1.sales_line_item_detail.item_ref.to_i).to eq 1
    expect(line_item1.sales_line_item_detail.unit_price).to eq 20.0
    expect(line_item1.sales_line_item_detail.quantity).to eq 1
    expect(line_item1.sales_line_item_detail.tax_code_ref.to_s).to eq 'NON'
    expect(line_item1.sales_line_item_detail.service_date.to_date).to eq Date.civil(2012,4,17)

    line_item3 = estimate.line_items[2]
    expect(line_item3.sub_total_item?).to be true
    #expect(line_item3.sub_total_line_detail.amount).to eq 60.0

    expect(estimate.customer_ref.value).to eq "32"
    expect(estimate.customer_ref.name).to eq "400a vnAPSdnwcAnjXiAjuduR"
    expect(estimate.customer_memo).to eq "This Estimate is a guestimate"

    billing_address = estimate.billing_address
    expect(billing_address).to_not be_nil
    expect(billing_address.id).to eq "7"
    expect(billing_address.line1).to eq "bill line1"
    expect(billing_address.city).to eq "Billville"
    expect(billing_address.country).to eq "USA"
    expect(billing_address.country_sub_division_code).to eq "CA"
    expect(billing_address.postal_code).to eq "12345"
    expect(billing_address.lat).to eq "42.8142432"
    expect(billing_address.lon).to eq "-73.9395687"

    shipping_address = estimate.shipping_address
    expect(shipping_address).to_not be_nil
    expect(shipping_address.id).to eq "8"
    expect(shipping_address.line1).to eq "ship line1"
    expect(shipping_address.city).to eq "Shipville"
    expect(shipping_address.country).to eq "USA"
    expect(shipping_address.country_sub_division_code).to eq "CA"
    expect(shipping_address.postal_code).to eq "12345"
    expect(shipping_address.lat).to eq "42.8142432"
    expect(shipping_address.lon).to eq "-73.9395687"

    expect(estimate.total_amount).to eq 60.00
    expect(estimate.apply_tax_after_discount?).to be false
    expect(estimate.print_status).to eq 'NotSet'
    expect(estimate.email_status).to eq 'NeedToSend'
    expect(estimate.bill_email.address).to eq 'sam@abc.com'
    expect(estimate.expiration_date.to_date).to eq Date.civil(2012,4,27)
    expect(estimate.accepted_by).to eq "AcceptedBySpiderman"
    expect(estimate.accepted_date.to_date).to eq Date.civil(2012,4,20)
  end

  it "should require line items for create / update" do
    estimate = Quickbooks::Model::Estimate.new
    expect(estimate.valid?).to be false
    expect(estimate.errors.keys.include?(:line_items)).to be true
  end

  it "should require customer_ref for create / update" do
    estimate = Quickbooks::Model::Estimate.new
    expect(estimate.valid?).to be false
    expect(estimate.errors.keys.include?(:customer_ref)).to be true
  end

  it "is valid with line_items and customer_ref" do
    estimate = Quickbooks::Model::Estimate.new
    estimate.customer_id = 2
    estimate.line_items << Quickbooks::Model::InvoiceLineItem.new

    expect(estimate.valid?).to be true
  end

  it "can properly convert to/from BigDecimal" do
    input_xml = fixture("estimate.xml")
    estimate = Quickbooks::Model::Estimate.from_xml(input_xml)
    line1 = estimate.line_items.first
    expect(line1).to_not be_nil
    expect(line1.amount).to eq 20.0
    expect(line1.amount.class).to eq BigDecimal

    xml = Nokogiri(estimate.to_xml.to_s)
    node = xml.xpath("//Estimate/Line/Amount")[0]
    expect(node).to_not be_nil
    expect(node.content).to eq "20.0"
  end

  describe "#global_tax_calculation" do
    subject { Quickbooks::Model::Estimate.new }
    it_should_behave_like "a model with a valid GlobalTaxCalculation", "TaxInclusive"
    it_should_behave_like "a model with a valid GlobalTaxCalculation", "TaxExcluded"
    it_should_behave_like "a model with a valid GlobalTaxCalculation", "NotApplicable"
    it_should_behave_like "a model with a valid GlobalTaxCalculation", ""
    it_should_behave_like "a model with an invalid GlobalTaxCalculation"
  end
end
