describe "Quickbooks::Model::TaxAgency" do
  it "parse from XML" do
    xml = fixture("tax_agency.xml")
    item = Quickbooks::Model::TaxAgency.from_xml(xml)

    item.id.should == "1"
    item.sync_token.should == 0
    item.meta_data.should_not be_nil
    item.display_name.should == "First TaxAgency"
    item.tax_tracked_on_purchases?.should be false
    item.tax_tracked_on_sales?.should be true
  end

  it "should require display_name for create / update" do
    invoice = Quickbooks::Model::TaxAgency.new
    invoice.should_not be_valid
    invoice.errors.keys.include?(:display_name).should be true
  end

end
