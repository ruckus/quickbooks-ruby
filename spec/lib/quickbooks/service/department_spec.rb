describe "Quickbooks::Service::Department" do
  before(:all) do
    construct_service :department
  end

  it "can query for departments" do
    xml = fixture("departments.xml")
    model = Quickbooks::Model::Department
    stub_http_request(:get, @service.url_for_query, ["200", "OK"], xml)
    departments = @service.query
    departments.entries.count.should == 3
    department1 = departments.entries[0]
    department1.name.should == 'Sales Department'
    department2 = departments.entries[1]
    department2.name.should == 'Support Department'
    department3 = departments.entries[2]
    department3.name.should == 'QA Department'
    department3.parent_ref.to_i.should == 2
  end

  it "can fetch a department by ID" do
    xml = fixture("fetch_department_by_id.xml")
    model = Quickbooks::Model::Department
    stub_http_request(:get, "#{@service.url_for_resource(model::REST_RESOURCE)}/2", ["200", "OK"], xml)
    department = @service.fetch_by_id(2)
    department.fully_qualified_name.should == 'Marketing Department'
  end

  it "can create a department" do
    xml = fixture("fetch_department_by_id.xml")
    model = Quickbooks::Model::Department
    stub_http_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml)
    department = Quickbooks::Model::Department.new
    department.name = 'Marketing Department'
    department.sub_department = false
    department.valid_for_create?.should == true
    created_department = @service.create(department)
    created_department.id.should == "2"
  end

  it "cannot sparse update a department" do
    model = Quickbooks::Model::Department
    department = Quickbooks::Model::Department.new
    department.name = "My Cool Department"
    department.sync_token = 2
    department.id = 1
    xml = fixture("fetch_department_by_id.xml")
    department.valid_for_update?.should == true
    expect{ @service.update(department, :sparse => true) }.to raise_error(Quickbooks::InvalidModelException, /Department sparse update is not supported/)
  end

  it "can delete a department" do
    model = Quickbooks::Model::Department
    department = Quickbooks::Model::Department.new
    department.name = 'Marketing Department'
    department.sync_token = 1
    department.id = 2
    xml = fixture("deleted_department.xml")
    stub_http_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml, {}, true)
    department.valid_for_deletion?.should == true
    response = @service.delete(department)
    response.name.should == "#{department.name} (Deleted)"
    response.active?.should == false
  end

end
