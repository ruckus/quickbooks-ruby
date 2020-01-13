describe "Quickbooks::Model::TaxAgency" do
  it "parse from XML" do
    xml = fixture("tax_agency.xml")
    item = Quickbooks::Model::TaxAgency.from_xml(xml)

    expect(item.id).to eq("1")
    expect(item.sync_token).to eq(0)
    expect(item.meta_data).not_to be_nil
    expect(item.display_name).to eq("First TaxAgency")
    expect(item.tax_tracked_on_purchases?).to be false
    expect(item.tax_tracked_on_sales?).to be true
  end

  it "should require display_name for create / update" do
    invoice = Quickbooks::Model::TaxAgency.new
    expect(invoice).not_to be_valid
    expect(invoice.errors.keys.include?(:display_name)).to be true
  end

end
