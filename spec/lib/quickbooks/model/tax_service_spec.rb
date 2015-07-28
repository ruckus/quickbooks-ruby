describe "Quickbooks::Model::TaxService" do
  it "parse from XML" do
    xml = fixture("tax_service.xml")
    item = Quickbooks::Model::TaxService.from_xml(xml)

    item.tax_code_id.should == "1"
    item.tax_code.should_not be_nil
    item.tax_rate_details.length.should == 1

    tax_rate_detail_line = item.tax_rate_details.first
    tax_rate_detail_line.tax_rate_id.should == "1"
    tax_rate_detail_line.tax_rate_name.should_not be_nil
    tax_rate_detail_line.rate_value.should == "3.5"
    tax_rate_detail_line.tax_agency_id.should == "2"
    tax_rate_detail_line.tax_applicable_on.should == "Sales"
  end

  it "should require tax_code for create" do
    ts = Quickbooks::Model::TaxService.new
    ts.should_not be_valid
    ts.errors.keys.include?(:tax_code).should be_true
  end

end
