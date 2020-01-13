describe Quickbooks::Service::Account do
  before(:all) do
    construct_service :account
  end

  it "can query for accounts" do
    xml = fixture("accounts.xml")
    stub_http_request(:get, @service.url_for_query, ["200", "OK"], xml, {}, true)

    accounts = @service.query
    expect(accounts.entries.count).to eq(10)

    sales = accounts.entries.first
    expect(sales.name).to eq('Cost of Goods Sold')
  end

  it "can fetch an account by ID" do
    xml = fixture("fetch_account_by_id.xml")
    model = Quickbooks::Model::Account
    stub_http_request(:get, "#{@service.url_for_resource(model::REST_RESOURCE)}/1", ["200", "OK"], xml)
    account = @service.fetch_by_id(1)

    expect(account.name).to eq("Sales of Product Income")
    expect(account.classification).to eq(Quickbooks::Model::Account::REVENUE)
    expect(account.tax_account?).to eq(nil)
    expect(account.currency_ref.to_s).to eq('USD')
    expect(account.current_balance).to eq(0)
    expect(account.current_balance_with_sub_accounts).to eq(0)
  end
end
