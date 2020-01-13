describe "Quickbooks::Service::Item" do
  before(:all) do
    construct_service :item
  end

  it "can query for items" do
    xml = fixture("items.xml")
    model = Quickbooks::Model::Item

    stub_http_request(:get, @service.url_for_query, ["200", "OK"], xml)
    items = @service.query
    expect(items.entries.count).to eq(2)

    doll = items.entries.first
    expect(doll.name).to eq('Plush Baby Doll')
  end

  it "can fetch an Item by ID" do
    xml = fixture("fetch_item_by_id.xml")
    model = Quickbooks::Model::Item
    stub_http_request(:get, "#{@service.url_for_base}/item/2?minorversion=#{Quickbooks::Model::Item::MINORVERSION}", ["200", "OK"], xml)
    item = @service.fetch_by_id(2)
    expect(item.name).to eq("Plush Baby Doll")
  end

  it "cannot create an Item without a name" do
    item = Quickbooks::Model::Item.new

    # invalid because the name contains a colon
    expect do
      @service.create(item)
    end.to raise_error(Quickbooks::InvalidModelException)

    expect(item.valid?).to eq(false)
    expect(item.errors.keys.include?(:name)).to eq(true)
  end

  it "can create an Item" do
    xml = fixture("fetch_item_by_id.xml")
    model = Quickbooks::Model::Item

    stub_http_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml)

    item = Quickbooks::Model::Item.new
    item.name = "Comfy Pillow"

    created_item = @service.create(item)
    expect(created_item.id).to eq("2")
  end

  it "can create an Item with minorversion and requestid" do
    xml = fixture("fetch_item_by_id.xml")
    model = Quickbooks::Model::Item

    url = "#{@service.url_for_resource(model::REST_RESOURCE)}&requestid=123"
    stub_http_request(:post, url, ["200", "OK"], xml)

    item = Quickbooks::Model::Item.new
    item.name = "Comfy Pillow"

    created_item = @service.create(item, query: {requestid: 123})
    expect(created_item.id).to eq("2")
  end

  it "can sparse update an Item" do
    model = Quickbooks::Model::Item
    item = Quickbooks::Model::Item.new
    item.name = "Plush Baby Doll"
    item.sync_token = 2
    item.id = 1
    # purposefully unset an element - which if we were not using
    # sparse update would cause Intuit to unset the field remotely as well.
    item.description = nil

    xml = fixture("fetch_item_by_id.xml")
    stub_http_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml, {}, true)

    update_response = @service.update(item, :sparse => true)
    expect(update_response.name).to eq('Plush Baby Doll')
    expect(update_response.description).not_to be_nil
  end

  it "can delete an Item" do
    model = Quickbooks::Model::Item
    item = Quickbooks::Model::Item.new
    item.name = "Thrifty Meats"
    item.sync_token = 2
    item.id = 1

    xml = fixture("item_delete_success_response.xml")
    stub_http_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml, {}, true)

    response = @service.delete(item)
    expect(response.active?).to be_nil
  end

end
