describe "Quickbooks::Model::CustomerType" do

  it "parse from XML" do
    xml = fixture("customer_type.xml")
    customer_type = Quickbooks::Model::CustomerType.from_xml(xml)
    expect(customer_type.sync_token).to eq 1
    expect(customer_type.name).to eq 'Retail'
    expect(customer_type.active?).to eq true
  end

end
