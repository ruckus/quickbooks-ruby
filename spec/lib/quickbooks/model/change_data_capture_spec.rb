require 'nokogiri'

describe "Quickbooks::Model::ChangeDataCapture" do
  it "parse from XML" do
    xml = Nokogiri::XML(fixture("change_data_capture_response.xml"))
    response = Quickbooks::Model::ChangeDataCapture.new(xml: xml)
    response.all_types["Bill"].count.should == 2
    response.all_types["BillPayment"].count.should == 2
    response.all_types["Deposit"].count.should == 1
    response.all_types["Invoice"].count.should == 2
    response.all_types["Payment"].count.should == 1
  end

  it "should produce full models for returned entities" do
    xml = Nokogiri::XML(fixture("change_data_capture_response.xml"))
    response = Quickbooks::Model::ChangeDataCapture.new(xml: xml)
    response.time == "2016-04-13T07:52:34.949-07:00"
    invoice = response.all_types["Invoice"].first

    invoice.meta_data.should_not be_nil
    invoice.doc_number.should == "1033"
    invoice.txn_date.to_date.should == Date.civil(2016, 02, 23)
    invoice.line_items.should_not be_nil
    invoice.line_items.length.should == 4
    invoice.currency_ref.to_s.should == 'USD'
    invoice.currency_ref.name.should == 'United States Dollar'

    line_item1 = invoice.line_items[0]
    line_item1.id.should == "1"
    line_item1.line_num.should == 1
    line_item1.description.should == 'Rock Fountain'
    line_item1.amount.should == 275.00
    line_item1.sales_item?.should == true
    line_item1.sales_line_item_detail.should_not be_nil
    line_item1.sales_line_item_detail.item_ref.to_i.should == 5
    line_item1.sales_line_item_detail.unit_price.should == 275.00
    line_item1.sales_line_item_detail.quantity.should == 1
    line_item1.sales_line_item_detail.tax_code_ref.to_s.should == 'TAX'

    invoice.customer_ref.value.should == "10"
    invoice.customer_ref.name.should == "Geeta Kalapatapu"
    invoice.customer_memo.should == "Thank you for your business and have a great day!"
  end

  it "should create ChangeModels for deleted entities" do
    xml = Nokogiri::XML(fixture("change_data_capture_response.xml"))
    response = Quickbooks::Model::ChangeDataCapture.new(xml: xml)
    invoice = response.all_types["Invoice"].last

    invoice.status.should == "Deleted"
  end
end