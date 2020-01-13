describe "Quickbooks::Model::TaxCode" do
  it "parse from XML" do
    xml = fixture("tax_code.xml")
    item = Quickbooks::Model::TaxCode.from_xml(xml)
    expect(item.id).to eq("2")
    expect(item.sync_token).to eq(0)
    expect(item.meta_data).not_to be_nil
    expect(item.name).to eq("Stupid tax")
    expect(item.description).to eq("Stupid tax")
    expect(item).to be_active
    expect(item).to be_taxable
    expect(item).to be_tax_group

    sales_tax_rate_detail = item.sales_tax_rate_list.tax_rate_detail.first
    expect(sales_tax_rate_detail.tax_rate_ref.value).to eq("1")
    expect(sales_tax_rate_detail.tax_rate_ref.name).to eq("Stupid tax")
    expect(sales_tax_rate_detail.tax_type_applicable).to eq("TaxOnAmount")
    expect(sales_tax_rate_detail.tax_order).to eq("0")

    purchase_tax_rate_detail = item.purchase_tax_rate_list.tax_rate_detail.first
    expect(purchase_tax_rate_detail.tax_rate_ref.value).to eq("2")
    expect(purchase_tax_rate_detail.tax_rate_ref.name).to eq("Banana tax")
    expect(purchase_tax_rate_detail.tax_type_applicable).to eq("TaxOnAmount")
    expect(purchase_tax_rate_detail.tax_order).to eq("0")
  end
end
