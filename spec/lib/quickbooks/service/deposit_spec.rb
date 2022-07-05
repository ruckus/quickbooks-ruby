describe "Quickbooks::Service::Deposit" do
  before(:all) { construct_service :deposit }

  # let(:customer_ref) { Quickbooks::Model::BaseReference.new(42) }
  let(:model) { Quickbooks::Model::Deposit }
  let(:deposit) { model.new :id => 8748 }
  let(:resource) { model::REST_RESOURCE }

  it "can query for deposits" do
    stub_http_request(:get,
                 @service.url_for_query,
                 ["200", "OK"],
                 fixture("deposits.xml"))

    deposits = @service.query

    expect(deposits.entries.count).to eq(5)
    deposit = deposits.entries.first
    expect(deposit.private_note).to eq("Test Deposit")
  end

  it "can fetch a deposit by ID" do
    stub_http_request(:get,
                 "#{@service.url_for_resource(resource)}/1",
                 ["200", "OK"],
                 fixture("fetch_deposit_by_id.xml"))

    payment = @service.fetch_by_id(1)

    expect(payment.private_note).to eq("Deposit Note")
  end

  it "can create a deposit" do
    stub_http_request(:post,
                 @service.url_for_resource(resource),
                 ["200", "OK"],
                 fixture("fetch_deposit_by_id.xml"))

    deposit.line_items << Quickbooks::Model::DepositLineItem.new
    created_deposit = @service.create(deposit)

    expect(created_deposit.id).to eq(62)
  end

  it "can sparse update a deposit" do
    deposit.total = 20.0
    stub_http_request(:post,
                 @service.url_for_resource(resource),
                 ["200", "OK"],
                 fixture("fetch_deposit_by_id.xml"),
                 {},
                 true)

    deposit.line_items << Quickbooks::Model::DepositLineItem.new
    update_response = @service.update(deposit, :sparse => true)

    expect(update_response.total).to eq(218.75)
  end

  it "can delete a deposit" do
    stub_http_request(:post,
                 "#{@service.url_for_resource(resource)}?operation=delete",
                 ["200", "OK"],
                 fixture("deposit_delete_success_response.xml"))

    response = @service.delete(deposit)

    expect(response).to be true
  end

  it "properly outputs BigDecimal fields" do
    deposit.total = "42"

    xml = deposit.to_xml

    expect(xml.at("TotalAmt").text).to eq("42.0")
  end
end
