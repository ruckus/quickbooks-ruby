require 'nokogiri'

describe "Quickbooks::Model::ChangeDataCapture" do
  it "parse from XML" do
    xml = Nokogiri::XML(fixture("change_data_capture_response.xml"))
    response = Quickbooks::Model::ChangeDataCapture.new(xml: xml)

    expect(response.all_types["Bill"].count).to eq 2
    expect(response.all_types["BillPayment"].count).to eq 2
    expect(response.all_types["Deposit"].count).to eq 1
    expect(response.all_types["Invoice"].count).to eq 2
    expect(response.all_types["Payment"].count).to eq 1
  end

  it "should produce full models for returned entities" do
    xml = Nokogiri::XML(fixture("change_data_capture_response.xml"))
    response = Quickbooks::Model::ChangeDataCapture.new(xml: xml)
    response.time == "2016-04-13T07:52:34.949-07:00"
    invoice = response.all_types["Invoice"].first

    expect(invoice.meta_data).not_to be_nil
    expect(invoice.doc_number).to eq "1033"
    expect(invoice.txn_date.to_date).to eq Date.civil(2016, 02, 23)
    expect(invoice.line_items).not_to be_nil
    expect(invoice.line_items.length).to eq 4
    expect(invoice.currency_ref.to_s).to eq 'USD'
    expect(invoice.currency_ref.name).to eq 'United States Dollar'

    line_item1 = invoice.line_items[0]
    expect(line_item1.id).to eq "1"
    expect(line_item1.line_num).to eq 1
    expect(line_item1.description).to eq 'Rock Fountain'
    expect(line_item1.amount).to eq  275.00
    expect(line_item1.sales_item?).to eq  true
    expect(line_item1.sales_line_item_detail).not_to be_nil
    expect(line_item1.sales_line_item_detail.item_ref.to_i).to eq 5
    expect(line_item1.sales_line_item_detail.unit_price).to eq 275.00
    expect(line_item1.sales_line_item_detail.quantity).to eq  1
    expect(line_item1.sales_line_item_detail.tax_code_ref.to_s).to eq  'TAX'

    expect(invoice.customer_ref.value).to eq  "10"
    expect(invoice.customer_ref.name).to eq  "Geeta Kalapatapu"
    expect(invoice.customer_memo).to eq  "Thank you for your business and have a great day!"
  end

  it "should create ChangeModels for deleted entities" do
    xml = Nokogiri::XML(fixture("change_data_capture_response.xml"))
    response = Quickbooks::Model::ChangeDataCapture.new(xml: xml)
    invoice = response.all_types["Invoice"].last

    expect(invoice.status).to eq "Deleted"
  end
end
