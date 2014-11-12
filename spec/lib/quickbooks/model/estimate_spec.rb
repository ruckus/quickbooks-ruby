require 'nokogiri'

describe "Quickbooks::Model::Estimate" do

  it "parse from XML" do
    xml = fixture("estimate.xml")
    estimate = Quickbooks::Model::Estimate.from_xml(xml)
    estimate.sync_token.should == 0
    estimate.id.should == 12

    estimate.meta_data.should_not be_nil
    estimate.doc_number.should == "3BcMMoa4YQBuUbJucPeR"
    estimate.txn_date.to_date.should == Date.civil(2012,4,20)
    estimate.custom_fields.length.should == 3

    estimate.line_items.should_not be_nil
    estimate.line_items.length.should == 3

    line_item1 = estimate.line_items[0]
    line_item1.id.should == 1
    line_item1.line_num.should == 1
    line_item1.description.should == 'dsfafdfasdfdsfasdfadsfasdfsad'
    line_item1.amount.should == 20.0
    line_item1.sales_item?.should == true
    line_item1.sales_line_item_detail.should_not be_nil
    line_item1.sales_line_item_detail.item_ref.to_i.should == 1
    line_item1.sales_line_item_detail.unit_price.should == 20.0
    line_item1.sales_line_item_detail.quantity.should == 1
    line_item1.sales_line_item_detail.tax_code_ref.to_s.should == 'NON'
    line_item1.sales_line_item_detail.service_date.to_date.should == Date.civil(2012,4,17)

    line_item3 = estimate.line_items[2]
    line_item3.sub_total_item?.should == true
    #line_item3.sub_total_line_detail.amount.should == 60.0

    estimate.customer_ref.value.should == "32"
    estimate.customer_ref.name.should == "400a vnAPSdnwcAnjXiAjuduR"
    estimate.customer_memo.should == "This Estimate is a guestimate"

    billing_address = estimate.billing_address
    billing_address.should_not be_nil
    billing_address.id.should == 7
    billing_address.line1.should == "bill line1"
    billing_address.city.should == "Billville"
    billing_address.country.should == "USA"
    billing_address.country_sub_division_code.should == "CA"
    billing_address.postal_code.should == "12345"
    billing_address.lat.should == "42.8142432"
    billing_address.lon.should == "-73.9395687"

    shipping_address = estimate.shipping_address
    shipping_address.should_not be_nil
    shipping_address.id.should == 8
    shipping_address.line1.should == "ship line1"
    shipping_address.city.should == "Shipville"
    shipping_address.country.should == "USA"
    shipping_address.country_sub_division_code.should == "CA"
    shipping_address.postal_code.should == "12345"
    shipping_address.lat.should == "42.8142432"
    shipping_address.lon.should == "-73.9395687"

    estimate.total_amount.should == 60.00
    estimate.apply_tax_after_discount?.should == false
    estimate.print_status.should == 'NotSet'
    estimate.email_status.should == 'NeedToSend'
    estimate.bill_email.address.should == 'sam@abc.com'
    estimate.expiration_date.to_date.should == Date.civil(2012,4,27)
    estimate.accepted_by.should == "AcceptedBySpiderman"
    estimate.accepted_date.to_date.should == Date.civil(2012,4,20)
  end

  it "should require line items for create / update" do
    estimate = Quickbooks::Model::Estimate.new
    estimate.valid?.should == false
    estimate.errors.keys.include?(:line_items).should == true
  end

  it "should require customer_ref for create / update" do
    estimate = Quickbooks::Model::Estimate.new
    estimate.valid?.should == false
    estimate.errors.keys.include?(:customer_ref).should == true
  end

  it "is valid with line_items and customer_ref" do
    estimate = Quickbooks::Model::Estimate.new
    estimate.customer_id = 2
    estimate.line_items << Quickbooks::Model::InvoiceLineItem.new

    estimate.valid?.should == true
  end

  it "can properly convert to/from BigDecimal" do
    input_xml = fixture("estimate.xml")
    estimate = Quickbooks::Model::Estimate.from_xml(input_xml)
    line1 = estimate.line_items.first
    line1.should_not be_nil
    line1.amount.should == 20.0
    line1.amount.class.should == BigDecimal

    xml = Nokogiri(estimate.to_xml.to_s)
    node = xml.xpath("//Estimate/Line/Amount")[0]
    node.should_not be_nil
    node.content.should == "20.0"
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
