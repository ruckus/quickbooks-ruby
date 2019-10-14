describe Quickbooks::Service::Account do
  before(:all) do
    construct_service :attachable
  end

  it "can query for attachables" do
    xml = fixture("attachables.xml")
    stub_http_request(:get, @service.url_for_query, ["200", "OK"], xml, {}, true)

    attachables = @service.query
    attachables.entries.count.should == 1

    monkey = attachables.entries.first
    monkey.file_name.should == 'monkey.jpg'
  end

  it "can create an attachble" do
    xml = fixture("attachable_create_response.xml")
    stub_http_request(:post, @service.url_for_resource('attachable'), ["200", "OK"], xml, {}, true)

    attachable = Quickbooks::Model::Attachable.new
    attachable.file_name = "monkey.jpg"
    attachable.note = "A note"
    entity = Quickbooks::Model::BaseReference.new(3, type: 'Customer')
    attachable.attachable_ref = Quickbooks::Model::AttachableRef.new(entity)
    n = Nokogiri::XML(attachable.to_xml.to_s)
    n.at('AttachableRef > EntityRef').content.should == '3'
    n.at('AttachableRef > EntityRef')[:type].should == 'Customer'
    response = @service.create(attachable)
    response.note.should == attachable.note
  end

end
