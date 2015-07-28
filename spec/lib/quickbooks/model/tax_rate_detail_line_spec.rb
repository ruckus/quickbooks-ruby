describe "Quickbooks::Model::TaxRateDetailLine" do
  it "parse from XML" do
    xml = fixture("tax_rate_detail_line.xml")
    item = Quickbooks::Model::TaxRateDetailLine.from_xml(xml)
    item.tax_rate_id.should == "1"
    item.tax_rate_name.should_not be_nil
    item.rate_value.should == "3.5"
    item.tax_agency_id.should == "2"
    item.tax_applicable_on.should == "Sales"
  end

  describe "TaxRateName" do
    it "should required for create without tax_rate_id" do
      line = Quickbooks::Model::TaxRateDetailLine.new
      line.should_not be_valid
      line.errors.keys.include?(:tax_rate_name).should be_true
    end

    it "should not required for create with tax_rate_id" do
      line = Quickbooks::Model::TaxRateDetailLine.new(tax_rate_id: 1)
      line.should be_valid
      line.errors.keys.include?(:tax_rate_name).should_not be_true
    end
  end

  describe "TaxAgencyId" do
    it "should required for create without tax_rate_id" do
      line = Quickbooks::Model::TaxRateDetailLine.new
      line.should_not be_valid
      line.errors.keys.include?(:tax_agency_id).should be_true
    end

    it "should not required for create with tax_rate_id" do
      line = Quickbooks::Model::TaxRateDetailLine.new(tax_rate_id: 1)
      line.should be_valid
      line.errors.keys.include?(:tax_agency_id).should be_false
    end
  end

  describe "RateValue" do
    it "should required for create without tax_rate_id" do
      line = Quickbooks::Model::TaxRateDetailLine.new
      line.should_not be_valid
      line.errors.keys.include?(:rate_value).should be_true
    end

    it "should not required for create with tax_rate_id" do
      line = Quickbooks::Model::TaxRateDetailLine.new(tax_rate_id: 1)
      line.should be_valid
      line.errors.keys.include?(:rate_value).should be_false
    end
  end

  describe "TaxRateId" do
    it "should required for create without tax_rate_name, tax_agency_id and rate_value" do
      line = Quickbooks::Model::TaxRateDetailLine.new(tax_rate_id: 1)
      line.should be_valid
      line.errors.keys.include?(:tax_rate_name).should be_false
      line.errors.keys.include?(:tax_agency_id).should be_false
      line.errors.keys.include?(:rate_value).should be_false
    end

    it "should not required for create with tax_rate_name, tax_agency_id and rate_value" do
      line = Quickbooks::Model::TaxRateDetailLine.new(tax_rate_name: 'rate spec', tax_agency_id: 1, rate_value: 3.4)
      line.should be_valid
      line.errors.keys.include?(:tax_rate_id).should be_false
    end
  end

end
