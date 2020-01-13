describe "Quickbooks::Service::Employee" do
  before(:all) do
    construct_service :employee
  end

  it "can query for employees" do
    xml = fixture("employees.xml")
    model = Quickbooks::Model::Employee
    stub_http_request(:get, @service.url_for_query, ["200", "OK"], xml)
    employees = @service.query
    expect(employees.entries.count).to eq(2)
    employee1 = employees.entries.first
    expect(employee1.display_name).to eq('John Miller')
    employee2 = employees.entries.last
    expect(employee2.display_name).to eq('Horace Miller')
  end

  it "can fetch an employee by ID" do
    xml = fixture("fetch_employee_by_id.xml")
    model = Quickbooks::Model::Employee
    stub_http_request(:get, "#{@service.url_for_resource(model::REST_RESOURCE)}/2", ["200", "OK"], xml)
    employee = @service.fetch_by_id(2)
    expect(employee.print_on_check_name).to eq('Lindy Miller')
  end

  it "cannot create an employee with an invalid display_name" do
    employee = Quickbooks::Model::Employee.new
    employee.display_name = 'Tractor:Trailer' # invalid because the name contains a colon
    expect(employee.valid?).to eq(false)
    expect(employee.valid_for_create?).to eq(false)
    expect{ @service.create(employee) }.to raise_error(Quickbooks::InvalidModelException, /cannot contain a colon/)
    expect(employee.errors.keys.include?(:display_name)).to eq(true)
  end

  it "cannot create an employee with an invalid email" do
    employee = Quickbooks::Model::Employee.new
    employee.email_address = "foobar.com"
    expect(employee.valid_for_create?).to eq(false)
    expect(employee.valid?).to eq(false)
    expect{ @service.create(employee) }.to raise_error(Quickbooks::InvalidModelException, /Email address must contain/)
    expect(employee.errors.keys.include?(:primary_email_address)).to eq(true)
  end

  it "can create a employee" do
    xml = fixture("fetch_employee_by_id.xml")
    model = Quickbooks::Model::Employee
    stub_http_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml)
    employee = Quickbooks::Model::Employee.new
    employee.organization = false
    employee.email_address = "lindy.employee@intuit.com"
    address = Quickbooks::Model::PhysicalAddress.new
    address.line1 = '99 N. Elm Street'
    address.city = 'Middlesburg'
    address.country_sub_division_code = 'VA'
    address.postal_code = '93242'
    employee.address = address
    expect(employee.valid_for_create?).to eq(true)
    created_employee = @service.create(employee)
    expect(created_employee.id).to eq("2")
  end

  it "cannot sparse update a employee" do
    model = Quickbooks::Model::Employee
    employee = Quickbooks::Model::Employee.new
    employee.display_name = "Employee Corporation"
    employee.sync_token = 2
    employee.id = 1
    xml = fixture("fetch_employee_by_id.xml")
    expect(employee.valid_for_update?).to eq(true)
    expect{ @service.update(employee, :sparse => true) }.to raise_error(Quickbooks::InvalidModelException, /Employee sparse update is not supported/)
  end

  it "can delete a employee" do
    model = Quickbooks::Model::Employee
    employee = Quickbooks::Model::Employee.new
    employee.display_name = 'Lindy Miller'
    employee.sync_token = 1
    employee.id = 2
    xml = fixture("deleted_employee.xml")
    stub_http_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml, {}, true)
    expect(employee.valid_for_deletion?).to eq(true)
    response = @service.delete(employee)
    expect(response.display_name).to eq("#{employee.display_name} (Deleted)")
    expect(response.active?).to eq(false)
  end

end
