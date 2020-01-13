describe "Quickbooks::Model::TaxRate" do
  it "parse from XML" do
    xml = fixture("tax_rate.xml")
    item = Quickbooks::Model::TaxRate.from_xml(xml)
    expect(item.id).to eq("9")
    expect(item.sync_token).to eq(0)
    expect(item.meta_data).not_to be_nil
    expect(item.name).to eq("Santa Clara County")
    expect(item.description).to eq("Sales Tax")
    expect(item).to be_active
    expect(item.rate_value).to eq(0.5)
    expect(item.agency_ref.value).to eq("3")
    expect(item.effective_tax_rate).not_to be_nil
    expect(item.special_tax_type).to eq("NONE")
    expect(item.display_type).to eq("ReadOnly")
  end
end
