describe "Quickbooks::Service::Employee" do
  before(:all) do
    construct_service :employee
  end

  it "can query for employees" do
    xml = fixture("employees.xml")
    model = Quickbooks::Model::Employee
    stub_http_request(:get, @service.url_for_query, ["200", "OK"], xml)
    employees = @service.query
    employees.entries.count.should == 2
    employee1 = employees.entries.first
    employee1.display_name.should == 'John Miller'
    employee2 = employees.entries.last
    employee2.display_name.should == 'Horace Miller'
  end

  it "can fetch an employee by ID" do
    xml = fixture("fetch_employee_by_id.xml")
    model = Quickbooks::Model::Employee
    stub_http_request(:get, "#{@service.url_for_resource(model::REST_RESOURCE)}/2", ["200", "OK"], xml)
    employee = @service.fetch_by_id(2)
    employee.print_on_check_name.should == 'Lindy Miller'
  end

  it "cannot create an employee with an invalid display_name" do
    employee = Quickbooks::Model::Employee.new
    employee.display_name = 'Tractor:Trailer' # invalid because the name contains a colon
    employee.valid?.should == false
    employee.valid_for_create?.should == false
    expect{ @service.create(employee) }.to raise_error(Quickbooks::InvalidModelException, /cannot contain a colon/)
    employee.errors.keys.include?(:display_name).should == true
  end

  it "cannot create an employee with an invalid email" do
    employee = Quickbooks::Model::Employee.new
    employee.email_address = "foobar.com"
    employee.valid_for_create?.should == false
    employee.valid?.should == false
    expect{ @service.create(employee) }.to raise_error(Quickbooks::InvalidModelException, /Email address must contain/)
    employee.errors.keys.include?(:primary_email_address).should == true
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
    employee.valid_for_create?.should == true
    created_employee = @service.create(employee)
    created_employee.id.should == "2"
  end

  it "cannot sparse update a employee" do
    model = Quickbooks::Model::Employee
    employee = Quickbooks::Model::Employee.new
    employee.display_name = "Employee Corporation"
    employee.sync_token = 2
    employee.id = 1
    xml = fixture("fetch_employee_by_id.xml")
    employee.valid_for_update?.should == true
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
    employee.valid_for_deletion?.should == true
    response = @service.delete(employee)
    response.display_name.should == "#{employee.display_name} (Deleted)"
    response.active?.should == false
  end

end
