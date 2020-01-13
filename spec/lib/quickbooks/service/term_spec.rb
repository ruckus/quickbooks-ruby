describe "Quickbooks::Service::Term" do
  before(:all) { construct_service :term }

  let(:model) { Quickbooks::Model::Term }
  let(:resource) { model::REST_RESOURCE }
  let(:term) { model.new :id => 11, :name => "Sample Term" }

  it "can query for terms" do
    stub_http_request(:get, @service.url_for_query, ["200", "OK"], fixture("terms.xml"))

    terms = @service.query

    expect(terms.entries.count).to eq(1)
    term = terms.entries.first
    expect(term.name).to eq("TermForV3Testing-1373590184130")
  end

  it "can fetch a term by ID" do
    stub_http_request(:get,
                 "#{@service.url_for_resource(resource)}/11",
                 ["200", "OK"],
                 fixture("term_by_id.xml"))

    term = @service.fetch_by_id(11)

    expect(term.name).to eq("null-1373590184786")
  end

  it "can create a term" do
    stub_http_request(:post,
                 @service.url_for_resource(resource),
                 ["200", "OK"],
                 fixture("fetch_term_by_id.xml"))

    created_term = @service.create(term)

    expect(created_term.id).to eq("11")
  end

  it "can sparse update a term" do
    stub_http_request(:post,
                 @service.url_for_resource(resource),
                 ["200", "OK"],
                 fixture("fetch_term_by_id.xml"),
                 {},
                 true)

    updated_term = @service.update(term, :sparse => true)

    expect(updated_term.name).to eq("TermForV3Testing-1373590184130")
  end

  it "can delete a term" do
    stub_http_request(:post,
                 "#{@service.url_for_resource(resource)}",
                 ["200", "OK"],
                 fixture("term_delete_success_response.xml"))

    updated_term = @service.delete(term)

    expect(updated_term).not_to be_active
  end
end
