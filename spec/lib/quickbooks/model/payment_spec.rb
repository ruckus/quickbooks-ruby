require 'nokogiri'

describe "Quickbooks::Model::Payment" do

  it "parse from XML" do
    xml = fixture("payment.xml")
    payment = Quickbooks::Model::Payment.from_xml(xml)
    payment.sync_token.should == 2

    payment.meta_data.should_not be_nil
    payment.doc_number.should == "1001"
    payment.txn_date.to_date.should == Date.civil(2013, 11, 15)
    payment.private_note.should == "Statement Memo"
    payment.line_items.should_not be_nil
    payment.line_items.length.should == 2

    line_item1 = payment.line_items[0]
    line_item1.id.should == 1
    line_item1.line_num.should == 1
    line_item1.description.should == 'Plush Baby Doll'
    line_item1.amount.should == 50.0
    line_item1.sales_item?.should == true
    line_item1.sales_line_item_detail.should_not be_nil
    line_item1.sales_line_item_detail.item_ref.should == 1
    line_item1.sales_line_item_detail.unit_price.should == 50.0
    line_item1.sales_line_item_detail.quantity.should == 1
    line_item1.sales_line_item_detail.tax_code_ref.should == 'NON'

    line_item2 = payment.line_items[1]
    line_item2.sub_total_item?.should == true

    payment.customer_ref.value.should == "2"
    payment.customer_ref.name.should == "Sunset Bakery"


    payment.total_amount.should == 50.00
  end

  it "should require line items for create / update" do
    payment = Quickbooks::Model::Payment.new
    payment.valid?.should == false
    payment.errors.keys.include?(:line_items).should == true
  end

  it "should require customer_ref for create / update" do
    payment = Quickbooks::Model::Payment.new
    payment.valid?.should == false
    payment.errors.keys.include?(:customer_ref).should == true
  end

  it "is valid with line_items and customer_ref" do
    payment = Quickbooks::Model::Payment.new
    payment.customer_id = 2
    payment.line_items << Quickbooks::Model::InvoiceLineItem.new

    payment.valid?.should == true
  end

  
  it "can properly convert to/from BigDecimal" do
    input_xml = fixture("payment.xml")
    payment = Quickbooks::Model::Payment.from_xml(input_xml)
    line1 = payment.line_items.first
    line1.should_not be_nil
    line1.amount.should == 50.00

    xml = Nokogiri(payment.to_xml.to_s)
    node = xml.xpath("//Payment/Line/Amount")[0]
    node.should_not be_nil
    node.content.should == "50.0"
  end
end