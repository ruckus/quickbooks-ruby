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
end