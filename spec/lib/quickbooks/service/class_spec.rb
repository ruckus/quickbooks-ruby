describe "Quickbooks::Service::Class" do
  before(:all) do
    construct_service :class
  end

  it "can query for classes" do
    xml = fixture("classes.xml")
    model = Quickbooks::Model::Class
    stub_http_request(:get, @service.url_for_query, ["200", "OK"], xml)
    classes = @service.query
    classes.entries.count.should == 4
    class1 = classes.entries[0]
    class1.name.should == 'Design'
    class2 = classes.entries[1]
    class2.name.should == 'Development'
    class3 = classes.entries[2]
    class3.name.should == 'Product'
    class4 = classes.entries[3]
    class4.name.should == 'QA'
    class4.sub_class?.should == true
    class4.parent_ref.to_i.should == 3
  end

  it "can fetch a class by ID" do
    xml = fixture("fetch_class_by_id.xml")
    model = Quickbooks::Model::Class
    stub_http_request(:get, "#{@service.url_for_resource(model::REST_RESOURCE)}/2", ["200", "OK"], xml)
    classs = @service.fetch_by_id(2)
    classs.fully_qualified_name.should == 'Design'
  end

  it "can create a class" do
    xml = fixture("fetch_class_by_id.xml")
    model = Quickbooks::Model::Class
    stub_http_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml)
    classs = Quickbooks::Model::Class.new
    classs.name = 'Design'
    classs.sub_class = false
    classs.valid_for_create?.should == true
    created_classs = @service.create(classs)
    created_classs.id.should == "2"
  end

  it "cannot sparse update a class" do
    model = Quickbooks::Model::Class
    classs = Quickbooks::Model::Class.new
    classs.name = "My Cool Class"
    classs.sync_token = 2
    classs.id = 1
    xml = fixture("fetch_class_by_id.xml")
    classs.valid_for_update?.should == true
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
    classs.valid_for_deletion?.should == true
    response = @service.delete(classs)
    response.name.should == "#{classs.name} (Deleted)"
    response.active?.should == false
  end

end
