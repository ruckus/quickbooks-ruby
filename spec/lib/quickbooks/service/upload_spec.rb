describe Quickbooks::Service::Upload do
  before(:all) do
    construct_service :upload
  end

  it "can create an upload" do
    xml = fixture("upload_create_response.xml")
    stub_http_request(:post, @service.url_for_resource('upload'), ["200", "OK"], xml, {}, true)

    attachable = Quickbooks::Model::Attachable.new
    attachable.file_name = "monkey.jpg"
    attachable.note = "A note"
    entity = Quickbooks::Model::EntityRef.new
    entity.type = 'Customer'
    entity.value = 3
    attachable.attachable_ref = Quickbooks::Model::AttachableRef.new(entity)

    path = File.join(fixture_path, "monkey.jpg")
    mime = "image/jpeg"

    response = @service.upload(path, mime, attachable)

    expect(response.note).to eq(attachable.note)
  end

end
