describe Quickbooks::Service::TaxAgency do
  before(:all) { construct_service :tax_agency }

  before do
    subject.company_id = "9991111222"
    subject.access_token = construct_oauth
  end

  let(:model) { Quickbooks::Model::TaxAgency }
  let(:tax_agency) { model.new(display_name: 'First TaxAgency')}
  let(:resource) { model::REST_RESOURCE }

  it "can query tax agency" do
    stub_http_request(:get,
                 @service.url_for_query,
                 ["200", "OK"],
                 fixture("tax_agencies.xml"))
    tax_agencies = @service.query
    expect(tax_agencies.entries.count).to eq(1)
    expect(tax_agencies.entries.first.display_name).to eq("First TaxAgency")
  end

  it "can create tax agency" do
    xml = fixture("tax_agency_entity.xml")
    stub_http_request(:post, subject.url_for_resource(resource), ["200", "OK"], xml)

    entity = subject.create(tax_agency)
    expect(entity.display_name).to eq tax_agency.display_name
  end

  it "can not create tax agency without display_name" do
    agency = model.new

    expect {
      subject.create(agency)
    }.to raise_error(Quickbooks::InvalidModelException)

    expect(agency.errors.messages).to have_key(:display_name)
  end

end
