describe Quickbooks::Service::Account do
  before(:all) do
    construct_service :attachable
  end

  it "can query for attachables" do
    xml = fixture("attachables.xml")
    stub_request(:get, @service.url_for_query, ["200", "OK"], xml, true)

    attachables = @service.query
    attachables.entries.count.should == 1

    monkey = attachables.entries.first
    monkey.file_name.should == 'monkey.jpg'
  end

  it "can create an attachble" do
    xml = fixture("attachable_create_response.xml")
    stub_request(:post, @service.url_for_resource('attachable'), ["200", "OK"], xml, true)

    attachable = Quickbooks::Model::Attachable.new
    attachable.file_name = "monkey.jpg"
    attachable.note = "A note"
    entity = Quickbooks::Model::EntityRef.new
    entity.type = 'Customer'
    entity.value = 3
    attachable.attachable_ref = Quickbooks::Model::AttachableRef.new(entity)
    response = @service.create(attachable)

    response.note.should == attachable.note
  end

end
