describe "Quickbooks::Model::SalesItemLineDetail" do

  it "rate percent should be a decimal/float if set" do
    detail = Quickbooks::Model::SalesItemLineDetail.new
    detail.rate_percent = 10
    detail.to_xml.at_css('RatePercent').content.should == '10.0'
  end

  it "rate percent should not be included if not set" do
    detail = Quickbooks::Model::SalesItemLineDetail.new
    detail.to_xml.should_not =~ /RatePercent/
  end
end
