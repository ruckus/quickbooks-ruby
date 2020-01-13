describe "Quickbooks::Model::Employee" do

  it "parse from XML" do
    xml = fixture("employee.xml")
    employee = Quickbooks::Model::Employee.from_xml(xml)
    expect(employee.sync_token).to eq(0)
    expect(employee.organization?).to be false
    expect(employee.title).to be_nil
    expect(employee.given_name).to eq('Jenny')
    expect(employee.middle_name).to be_nil
    expect(employee.family_name).to eq('Miller')
    expect(employee.suffix).to be_nil
    expect(employee.display_name).to eq('Jenny Miller')
    expect(employee.print_on_check_name).to eq('Jenny Miller')
    expect(employee.active?).to eq(true)
    expect(employee.primary_phone.free_form_number).to eq('525-7891')
    expect(employee.mobile_phone).to be_nil
    expect(employee.primary_email_address.address).to eq('jenny.employee@intuit.com')
    expect(employee.address).not_to be_nil
    expect(employee.address.id).to eq("50")
    expect(employee.address.line1).to eq("45 N. Elm Street")
    expect(employee.address.city).to eq("Middlefield")
    expect(employee.address.country).to be_nil
    expect(employee.address.country_sub_division_code).to eq("CA")
    expect(employee.address.postal_code).to eq("93242")
    expect(employee.billable?).to be true
    expect(employee.billable_rate).to eq(115.00)
    expect(employee.birth_date).to eq(Date.civil(1995, 06, 01))
    expect(employee.gender).to eq('female')
    expect(employee.ssn).to eq('XXX-XX-XXXX')
    expect(employee.hired_date).to eq(Date.civil(2013, 11, 01))
  end

  it "can assign an email address" do
    employee = Quickbooks::Model::Employee.new
    the_email = "foo@example.org"
    employee.email_address = the_email
    expect(employee.email_address.is_a?(Quickbooks::Model::EmailAddress)).to eq(true)
    expect(employee.email_address.address).to eq(the_email)
  end

  it "can set the organization to true" do
    employee = Quickbooks::Model::Employee.new
    expect(employee.organization?).to be_nil
    employee.organization = true
    expect(employee.organization?).to be true
  end

  it "can't assign a bad email address" do
    employee = Quickbooks::Model::Employee.new
    employee.email_address = "foo+example.org"
    employee.valid?
    expect(employee.errors.keys).to include(:primary_email_address)
  end

  it "cannot update an invalid model" do
    employee = Quickbooks::Model::Employee.new
    expect(employee.valid_for_update?).to eq(false)
    expect(employee.to_xml_ns).to match('Employee')
    expect(employee.errors.keys).to include(:sync_token)
  end

end
