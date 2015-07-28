describe Quickbooks::Service::TaxService do
  before(:all) { construct_service :tax_service }

  before do
    subject.company_id = "9991111222"
    subject.access_token = construct_oauth
  end

  let(:model) { Quickbooks::Model::TaxService }
  let(:tax_service) { model.new(tax_code: 'First Tax Service')}
  let(:resource) { model::REST_RESOURCE }

  it "can create tax code" do
    xml = fixture("tax_service_entity.xml")
    stub_request(:post, subject.url_for_resource(resource), ["200", "OK"], xml)

    entity = subject.create(tax_service)
    expect(entity.tax_code).to eq tax_service.tax_code
  end

  it "can not create tax agency without tax_code" do
    ts = model.new
    expect {
      subject.create(ts)
    }.to raise_error(Quickbooks::InvalidModelException)
    expect(ts.errors.messages).to have_key(:tax_code)
  end

end
