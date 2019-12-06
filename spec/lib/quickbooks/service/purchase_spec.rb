describe "Quickbooks::Service::Purchase" do
  before(:all) do
    construct_service :purchase
    @resource_url = @service.url_for_resource(Quickbooks::Model::Purchase::REST_RESOURCE)
  end

  it "cannot create a Purchase without any line items" do
    purchase = Quickbooks::Model::Purchase.new
    expect(purchase.valid?).to be false
    expect(purchase.errors.keys.include?(:line_items)).to be true
  end

  it "created for account based expense" do
    xml = fixture("purchase_create.xml")
    stub_http_request(:post, @resource_url, ["200", "OK"], xml)

    purchase = Quickbooks::Model::Purchase.new
    purchase.payment_type = 'Cash'
    purchase.account_id = 36
    line_item = Quickbooks::Model::PurchaseLineItem.new
    line_item.amount = 419.99
    line_item.description = "Rink Liner"
    line_item.account_based_expense! do |detail|
      detail.account_id = 28
      detail.customer_id = 1
    end
    purchase.line_items << line_item
    result = @service.create(purchase)
    expect(result.id).to eq '160'
  end
end

