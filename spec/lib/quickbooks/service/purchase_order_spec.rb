describe "Quickbooks::Service::PurchaseOrder" do

  before(:all) do
    construct_service :purchase_order
  end

  it "can delete a vendor" do
    model = Quickbooks::Model::PurchaseOrder
    purchase_order = model.new
    xml = fixture("deleted_purchase_order.xml")
    stub_http_request(:post, %r{#{@service.url_for_resource(model::REST_RESOURCE)}}, ["200", "OK"], xml, {}, false)
    expect(@service.delete(purchase_order)).to eq true

  end

end
