describe "Quickbooks::Model::TaxService" do

  it "must include at least one TaxRateDetails item" do
    item = Quickbooks::Model::TaxService.new(tax_code: '123456')
    item.should_not be_valid
    item.errors.keys.include?(:tax_rate_details).should be_true
    item.errors.values.should include(["must have at least one item"])
  end

  it "TaxRateDetails item must be valid" do
    item = Quickbooks::Model::TaxService.new(tax_code: '123456')
    item.tax_rate_details << Quickbooks::Model::TaxRateDetailLine.new(tax_rate_name: item.tax_code, rate_value: '12.3', tax_agency_id: '2', tax_applicable_on: 'Sales')
    item.should be_valid
  end

  it "must be raise TaxRateDetails item validation errors" do
    item = Quickbooks::Model::TaxService.new(tax_code: '123456')
    item.tax_rate_details << Quickbooks::Model::TaxRateDetailLine.new(tax_rate_name: item.tax_code)
    item.should_not be_valid
  end

  it "must be raise duplicates TaxRateName errors" do
    item = Quickbooks::Model::TaxService.new(tax_code: '123456')
    item.tax_rate_details << Quickbooks::Model::TaxRateDetailLine.new(tax_rate_name: item.tax_code, rate_value: '12.3', tax_agency_id: '2', tax_applicable_on: 'Sales')
    item.tax_rate_details << Quickbooks::Model::TaxRateDetailLine.new(tax_rate_name: item.tax_code, rate_value: '12.3', tax_agency_id: '2', tax_applicable_on: 'Sales')
    item.should_not be_valid
    item.errors.keys.include?(:tax_rate_name).should be_true
    item.errors.values.should include(["Duplicate Tax Rate Name"])
  end

  describe "#from_json" do
    let(:params) {
      {
        "TaxCode"=>"MyTaxCodeName", "TaxCodeId"=>"5",
        "TaxRateDetails"=>[
          {"TaxRateName"=>"myTaxRateName", "TaxRateId"=>"5", "RateValue"=> 8,
          "TaxAgencyId"=>"1", "TaxApplicableOn"=>"Sales"}
        ]
      }
    }
    let(:params_invalid) { {} }

    it "should return TaxService instance with correct params" do
      ts = Quickbooks::Model::TaxService.from_json(params.to_json)
      ts.tax_code.should_not be_blank
      ts.tax_code_id.should_not be_blank
      ts.tax_rate_details.size.should == params['TaxRateDetails'].size
    end

    it "should return nil with incorrect params" do
      ts = Quickbooks::Model::TaxService.from_json(params_invalid.to_json)
      ts.should be_blank
    end
  end
end
