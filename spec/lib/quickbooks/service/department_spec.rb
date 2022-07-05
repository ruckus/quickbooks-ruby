describe "Quickbooks::Service::Department" do
  before(:all) do
    construct_service :department
  end

  it "can query for departments" do
    xml = fixture("departments.xml")
    model = Quickbooks::Model::Department
    stub_http_request(:get, @service.url_for_query, ["200", "OK"], xml)
    departments = @service.query
    expect(departments.entries.count).to eq(3)
    department1 = departments.entries[0]
    expect(department1.name).to eq('Sales Department')
    department2 = departments.entries[1]
    expect(department2.name).to eq('Support Department')
    department3 = departments.entries[2]
    expect(department3.name).to eq('QA Department')
    expect(department3.parent_ref.to_i).to eq(2)
  end

  it "can fetch a department by ID" do
    xml = fixture("fetch_department_by_id.xml")
    model = Quickbooks::Model::Department
    stub_http_request(:get, "#{@service.url_for_resource(model::REST_RESOURCE)}/2", ["200", "OK"], xml)
    department = @service.fetch_by_id(2)
    expect(department.fully_qualified_name).to eq('Marketing Department')
  end

  it "can create a department" do
    xml = fixture("fetch_department_by_id.xml")
    model = Quickbooks::Model::Department
    stub_http_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml)
    department = Quickbooks::Model::Department.new
    department.name = 'Marketing Department'
    department.sub_department = false
    expect(department.valid_for_create?).to eq(true)
    created_department = @service.create(department)
    expect(created_department.id).to eq("2")
  end

  it "cannot sparse update a department" do
    model = Quickbooks::Model::Department
    department = Quickbooks::Model::Department.new
    department.name = "My Cool Department"
    department.sync_token = 2
    department.id = 1
    xml = fixture("fetch_department_by_id.xml")
    expect(department.valid_for_update?).to eq(true)
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
    expect(department.valid_for_deletion?).to eq(true)
    response = @service.delete(department)
    expect(response.name).to eq("#{department.name} (Deleted)")
    expect(response.active?).to eq(false)
  end

end
