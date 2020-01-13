describe "Quickbooks::Model::CompanyCurrency" do
  it "parse from XML" do
    xml = fixture('company_currency.xml')
    company_currency = Quickbooks::Model::CompanyCurrency.from_xml(xml)
    
    expect(company_currency.id).to eq("1")
    expect(company_currency.sync_token).to eq(3)
    
    expect(company_currency.meta_data).not_to be_nil
    expect(company_currency.name).to eq("Euro")
    expect(company_currency.code).to eq("EUR")
    expect(company_currency.active?).to eq(true)
  end
end
