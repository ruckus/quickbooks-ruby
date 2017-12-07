describe "Quickbooks::Model::TaxRate" do
  it "parse from XML" do
    xml = fixture("tax_rate.xml")
    item = Quickbooks::Model::TaxRate.from_xml(xml)
    item.id.should == "9"
    item.sync_token.should == 0
    item.meta_data.should_not be_nil
    item.name.should == "Santa Clara County"
    item.description.should == "Sales Tax"
    item.should be_active
    item.rate_value.should == 0.5
    item.agency_ref.value.should == "3"
    item.effective_tax_rate.should_not be_nil
    item.special_tax_type.should == "NONE"
    item.display_type.should == "ReadOnly"
  end
end
