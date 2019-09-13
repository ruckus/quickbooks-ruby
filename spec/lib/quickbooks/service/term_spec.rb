describe "Quickbooks::Service::Term" do
  before(:all) { construct_service :term }

  let(:model) { Quickbooks::Model::Term }
  let(:resource) { model::REST_RESOURCE }
  let(:term) { model.new :id => 11, :name => "Sample Term" }

  it "can query for terms" do
    stub_http_request(:get, @service.url_for_query, ["200", "OK"], fixture("terms.xml"))

    terms = @service.query

    terms.entries.count.should == 1
    term = terms.entries.first
    term.name.should == "TermForV3Testing-1373590184130"
  end

  it "can fetch a term by ID" do
    stub_http_request(:get,
                 "#{@service.url_for_resource(resource)}/11",
                 ["200", "OK"],
                 fixture("term_by_id.xml"))

    term = @service.fetch_by_id(11)

    term.name.should == "null-1373590184786"
  end

  it "can create a term" do
    stub_http_request(:post,
                 @service.url_for_resource(resource),
                 ["200", "OK"],
                 fixture("fetch_term_by_id.xml"))

    created_term = @service.create(term)

    created_term.id.should == "11"
  end

  it "can sparse update a term" do
    stub_http_request(:post,
                 @service.url_for_resource(resource),
                 ["200", "OK"],
                 fixture("fetch_term_by_id.xml"),
                 {},
                 true)

    updated_term = @service.update(term, :sparse => true)

    updated_term.name.should == "TermForV3Testing-1373590184130"
  end

  it "can delete a term" do
    stub_http_request(:post,
                 "#{@service.url_for_resource(resource)}",
                 ["200", "OK"],
                 fixture("term_delete_success_response.xml"))

    updated_term = @service.delete(term)

    updated_term.should_not be_active
  end
end
