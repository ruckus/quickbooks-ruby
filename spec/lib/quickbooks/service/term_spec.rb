describe "Quickbooks::Service::Term" do
  before(:all) { construct_service :term }

  it "can query for terms" do
    xml = fixture("terms.xml")
    model = Quickbooks::Model::Term

    stub_request(:get, @service.url_for_query, ["200", "OK"], xml)
    terms = @service.query
    terms.entries.count.should eq(1)

    term = terms.entries.first
    term.name.should eq("TermForV3Testing-1373590184130")
  end

  it "can fetch a term by ID" do
    xml = fixture("term_by_id.xml")
    model = Quickbooks::Model::Term
    stub_request(:get, "#{@service.url_for_resource(model::REST_RESOURCE)}/11", ["200", "OK"], xml)
    term = @service.fetch_by_id(11)
    term.name.should eq("null-1373590184786")
  end

  it "can create a term" do
    term = Quickbooks::Model::Term.new
    xml = fixture("fetch_term_by_id.xml")

    stub_request(:post, @service.url_for_resource(term.class::REST_RESOURCE), ["200", "OK"], xml)

    created_term = @service.create(term)
    created_term.id.should eq(11)
  end

  it "can sparse update a term" do
    term = Quickbooks::Model::Term.new {|term| term.name = "original name" }

    stub_request(:post, @service.url_for_resource(term.class::REST_RESOURCE),
                 ["200", "OK"], fixture("fetch_term_by_id.xml"), true)

    updated_term = @service.update(term, :sparse => true)

    updated_term.name.should eq("TermForV3Testing-1373590184130")
  end

  it "can delete a term" do
    term = Quickbooks::Model::Term.new {|term| term.id = 11 }
    url = "#{@service.url_for_resource(term.class::REST_RESOURCE)}"
    response = fixture("term_delete_success_response.xml")

    stub_request(:post, url, ["200", "OK"], response)

    updated_term = @service.delete(term)
    updated_term.should_not be_active
  end
end
