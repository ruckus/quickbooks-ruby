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

    deposits.entries.count.should eq(5)
    deposit = deposits.entries.first
    deposit.private_note.should eq("Test Deposit")
  end

  it "can fetch a deposit by ID" do
    stub_http_request(:get,
                 "#{@service.url_for_resource(resource)}/1",
                 ["200", "OK"],
                 fixture("fetch_deposit_by_id.xml"))

    payment = @service.fetch_by_id(1)

    payment.private_note.should eq("Deposit Note")
  end

  it "can create a deposit" do
    stub_http_request(:post,
                 @service.url_for_resource(resource),
                 ["200", "OK"],
                 fixture("fetch_deposit_by_id.xml"))

    deposit.line_items << Quickbooks::Model::DepositLineItem.new
    created_deposit = @service.create(deposit)

    created_deposit.id.should eq(62)
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

    update_response.total.should eq(218.75)
  end

  it "can delete a deposit" do
    stub_http_request(:post,
                 "#{@service.url_for_resource(resource)}?operation=delete",
                 ["200", "OK"],
                 fixture("deposit_delete_success_response.xml"))

    response = @service.delete(deposit)

    response.should be_true
  end

  it "properly outputs BigDecimal fields" do
    deposit.total = "42"

    xml = deposit.to_xml

    xml.at("TotalAmt").text.should eq("42.0")
  end
end
