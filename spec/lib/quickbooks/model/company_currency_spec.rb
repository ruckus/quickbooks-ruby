describe "Quickbooks::Model::CompanyCurrency" do
  it "parse from XML" do
    xml = fixture('company_currency.xml')
    company_currency = Quickbooks::Model::CompanyCurrency.from_xml(xml)
    
    company_currency.id.should == "1"
    company_currency.sync_token.should == 3
    
    company_currency.meta_data.should_not be_nil
    company_currency.name.should == "Euro"
    company_currency.code.should == "EUR"
    company_currency.active?.should == true
  end
end
