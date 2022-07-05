describe "Quickbooks::Service::Budget" do
  before(:all) do
    construct_service :budget
  end

  it "can query for budgets" do
    xml = fixture("budgets.xml")
    model = Quickbooks::Model::Invoice

    stub_http_request(:get, @service.url_for_query, ["200", "OK"], xml)
    budgets = @service.query
    expect(budgets.entries.count).to eq(2)
    first_budget = budgets.entries[0]
    expect(first_budget.id).to eq("1")
  end

  it "can fetch a Budget by ID" do
    xml = fixture("fetch_budget_by_id.xml")
    model = Quickbooks::Model::Budget
    stub_http_request(:get, "#{@service.url_for_resource(model::REST_RESOURCE)}/1", ["200", "OK"], xml)
    budget = @service.fetch_by_id(1)
    expect(budget.name).to eq("TestBudgie")
  end

end
