describe "Quickbooks::Model::TaxCode" do
  it "parse from XML" do
    xml = fixture("tax_code.xml")
    item = Quickbooks::Model::TaxCode.from_xml(xml)
    item.id.should == "2"
    item.sync_token.should == 0
    item.meta_data.should_not be_nil
    item.name.should == "Stupid tax"
    item.description.should == "Stupid tax"
    item.should be_active
    item.should be_taxable
    item.should be_tax_group

    sales_tax_rate_detail = item.sales_tax_rate_list.tax_rate_detail.first
    sales_tax_rate_detail.tax_rate_ref.value.should == "1"
    sales_tax_rate_detail.tax_rate_ref.name.should == "Stupid tax"
    sales_tax_rate_detail.tax_type_applicable.should == "TaxOnAmount"
    sales_tax_rate_detail.tax_order.should == "0"

    purchase_tax_rate_detail = item.purchase_tax_rate_list.tax_rate_detail.first
    purchase_tax_rate_detail.tax_rate_ref.value.should == "2"
    purchase_tax_rate_detail.tax_rate_ref.name.should == "Banana tax"
    purchase_tax_rate_detail.tax_type_applicable.should == "TaxOnAmount"
    purchase_tax_rate_detail.tax_order.should == "0"
  end
end
