describe "Quickbooks::Model::ExchangeRate" do
  it "parse from XML" do
    xml = fixture("exchange_rate.xml")
    item = Quickbooks::Model::ExchangeRate.from_xml(xml)
    expect(item.id).to eq("9")
    expect(item.sync_token).to eq(0)
    expect(item.meta_data).not_to be_nil
    expect(item.source_currency_code).to eq("EUR")
    expect(item.target_currency_code).to eq("USD")
    expect(item.rate).to eq(2.5)
    expect(item.as_of_date.to_date).to eq(Date.civil(2015, 07, 07))
  end
end
