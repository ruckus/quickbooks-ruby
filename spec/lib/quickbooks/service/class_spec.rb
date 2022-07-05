describe "Quickbooks::Service::Class" do
  before(:all) do
    construct_service :class
  end

  it "can query for classes" do
    xml = fixture("classes.xml")
    model = Quickbooks::Model::Class
    stub_http_request(:get, @service.url_for_query, ["200", "OK"], xml)
    classes = @service.query
    expect(classes.entries.count).to eq(4)
    class1 = classes.entries[0]
    expect(class1.name).to eq('Design')
    class2 = classes.entries[1]
    expect(class2.name).to eq('Development')
    class3 = classes.entries[2]
    expect(class3.name).to eq('Product')
    class4 = classes.entries[3]
    expect(class4.name).to eq('QA')
    expect(class4.sub_class?).to eq(true)
    expect(class4.parent_ref.to_i).to eq(3)
  end

  it "can fetch a class by ID" do
    xml = fixture("fetch_class_by_id.xml")
    model = Quickbooks::Model::Class
    stub_http_request(:get, "#{@service.url_for_resource(model::REST_RESOURCE)}/2", ["200", "OK"], xml)
    classs = @service.fetch_by_id(2)
    expect(classs.fully_qualified_name).to eq('Design')
  end

  it "can create a class" do
    xml = fixture("fetch_class_by_id.xml")
    model = Quickbooks::Model::Class
    stub_http_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml)
    classs = Quickbooks::Model::Class.new
    classs.name = 'Design'
    classs.sub_class = false
    expect(classs.valid_for_create?).to eq(true)
    created_classs = @service.create(classs)
    expect(created_classs.id).to eq("2")
  end

  it "cannot sparse update a class" do
    model = Quickbooks::Model::Class
    classs = Quickbooks::Model::Class.new
    classs.name = "My Cool Class"
    classs.sync_token = 2
    classs.id = 1
    xml = fixture("fetch_class_by_id.xml")
    expect(classs.valid_for_update?).to eq(true)
    expect{ @service.update(classs, :sparse => true) }.to raise_error(Quickbooks::InvalidModelException, /Class sparse update is not supported/)
  end

  it "can delete a class" do
    model = Quickbooks::Model::Class
    classs = Quickbooks::Model::Class.new
    classs.name = 'Design'
    classs.sync_token = 1
    classs.id = 2
    xml = fixture("deleted_class.xml")
    stub_http_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml, {}, true)
    expect(classs.valid_for_deletion?).to eq(true)
    response = @service.delete(classs)
    expect(response.name).to eq("#{classs.name} (Deleted)")
    expect(response.active?).to eq(false)
  end

end
