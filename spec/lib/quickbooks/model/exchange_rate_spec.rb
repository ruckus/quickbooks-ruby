describe "Quickbooks::Model::ExchangeRate" do
  it "parse from XML" do
    xml = fixture("exchange_rate.xml")
    item = Quickbooks::Model::ExchangeRate.from_xml(xml)
    item.id.should == "9"
    item.sync_token.should == 0
    item.meta_data.should_not be_nil
    item.source_currency_code.should == "EUR"
    item.target_currency_code.should == "USD"
    item.rate.should == 2.5
    item.as_of_date.to_date.should == Date.civil(2015, 07, 07)
  end
end
