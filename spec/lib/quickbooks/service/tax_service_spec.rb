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
  let(:url) { subject.url_for_resource(model::REST_RESOURCE) }
  let(:params) {
    {
      "TaxCode" => "MyTaxCodeName",
      "TaxCodeId" => "5",
      "TaxRateDetails" => [{
        "TaxRateName" => "myNewTaxRateName",
        "RateValue" => "8",
        "TaxAgencyId" => "1",
        "TaxApplicableOn" => "Sales"
      }]
    }
  }

  it "can create tax code" do
    stub_http_request(:post, url, ["200", "OK"], params.to_json)
    tax_service.tax_rate_details = tax_rate_details
    result = subject.create(tax_service)
    expect(result['TaxCodeId']).to eq "5"
  end

  it "catch exception if create tax code failed" do
    stub_http_request(:post, url, ["200", "OK"], params.to_json)
    expect {
      subject.create(tax_service)
    }.to raise_error(Quickbooks::InvalidModelException)
    expect(tax_service.errors.messages).to have_key(:tax_rate_details)
  end

  it "catch exception if create tax code failed" do
    stub_http_request(:post, url, ["200", "OK"], json_fixture(:tax_service_error_dup))
    tax_service.tax_rate_details = tax_rate_details
    expect {
      subject.create(tax_service)
    }.to raise_error(Quickbooks::IntuitRequestException, /The name supplied already exists/)
  end

  it "can not create tax service without tax_code" do
    ts = model.new
    expect {
      subject.create(ts)
    }.to raise_error(Quickbooks::InvalidModelException)
    expect(ts.errors.messages).to have_key(:tax_code)
  end

end
