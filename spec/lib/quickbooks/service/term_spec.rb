describe "Quickbooks::Service::Payment" do
  before(:all) do
    construct_service :term
  end

  it "can query for terms" do
    xml = fixture("terms.xml")
    model = Quickbooks::Model::Term

    stub_request(:get, @service.url_for_query, ["200", "OK"], xml, false)
    terms = @service.query
    terms.entries.count.should == 1

    first_term = terms.entries.first
    first_term.name.should == "Net30"
  end

  it "can fetch an Term by ID" do
    xml = fixture("fetch_term_by_id.xml")
    model = Quickbooks::Model::Term
    stub_request(:get, "#{@service.url_for_resource(model::REST_RESOURCE)}/1", ["200", "OK"], xml)
    term = @service.fetch_by_id(1)
    term.name.should == "Net30"
  end
end