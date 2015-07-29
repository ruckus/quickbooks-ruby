describe Quickbooks::Service::TaxService do
  before(:all) { construct_service :tax_service }

  before do
    subject.company_id = "9991111222"
    subject.access_token = construct_oauth
  end

  let(:model) { Quickbooks::Model::TaxService }
  let(:tax_rate_details) { [Quickbooks::Model::TaxRateDetailLine.new(
    tax_rate_name: 'First', rate_value: '12.3', tax_agency_id: '2', tax_applicable_on: 'Sales')]}

  let(:tax_service) { model.new(tax_code: 'First Tax Service')}
  let(:params) {
    {
      "TaxCode" => "MyTaxCodeName",
      "TaxRateDetails" => [{
        "TaxRateName" => "myNewTaxRateName",
        "RateValue" => "8",
        "TaxAgencyId" => "1",
        "TaxApplicableOn" => "Sales"
      }]
    }
  }

  it "can create tax code" do
    stub_request(:post, subject.url_for_resource, ["200", "OK"], params)
    expect {
      tax_service.tax_rate_details = tax_rate_details
      subject.create(tax_service)
    }.to_not raise_error(Quickbooks::InvalidModelException)
  end

  it "catch exception if create tax code failed" do
    stub_request(:post, subject.url_for_resource, ["200", "OK"], params)
    expect {
      subject.create(tax_service)
    }.to raise_error(Quickbooks::InvalidModelException)
    expect(tax_service.errors.messages).to have_key(:tax_rate_details)
  end

  it "can not create tax agency without tax_code" do
    ts = model.new
    expect {
      subject.create(ts)
    }.to raise_error(Quickbooks::InvalidModelException)
    expect(ts.errors.messages).to have_key(:tax_code)
  end

end
