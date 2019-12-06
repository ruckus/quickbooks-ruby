describe "Quickbooks::Model::Employee" do

  it "parse from XML" do
    xml = fixture("employee.xml")
    employee = Quickbooks::Model::Employee.from_xml(xml)
    employee.sync_token.should == 0
    employee.organization?.should be false
    employee.title.should be_nil
    employee.given_name.should == 'Jenny'
    employee.middle_name.should be_nil
    employee.family_name.should == 'Miller'
    employee.suffix.should be_nil
    employee.display_name.should == 'Jenny Miller'
    employee.print_on_check_name.should == 'Jenny Miller'
    employee.active?.should == true
    employee.primary_phone.free_form_number.should == '525-7891'
    employee.mobile_phone.should be_nil
    employee.primary_email_address.address.should == 'jenny.employee@intuit.com'
    employee.address.should_not be_nil
    employee.address.id.should == "50"
    employee.address.line1.should == "45 N. Elm Street"
    employee.address.city.should == "Middlefield"
    employee.address.country.should be_nil
    employee.address.country_sub_division_code.should == "CA"
    employee.address.postal_code.should == "93242"
    employee.billable?.should be true
    employee.billable_rate.should == 115.00
    employee.birth_date.should == Date.civil(1995, 06, 01)
    employee.gender.should == 'female'
    employee.ssn.should == 'XXX-XX-XXXX'
    employee.hired_date.should == Date.civil(2013, 11, 01)
  end

  it "can assign an email address" do
    employee = Quickbooks::Model::Employee.new
    the_email = "foo@example.org"
    employee.email_address = the_email
    employee.email_address.is_a?(Quickbooks::Model::EmailAddress).should == true
    employee.email_address.address.should == the_email
  end

  it "can set the organization to true" do
    employee = Quickbooks::Model::Employee.new
    employee.organization?.should be_nil
    employee.organization = true
    employee.organization?.should be true
  end

  it "can't assign a bad email address" do
    employee = Quickbooks::Model::Employee.new
    employee.email_address = "foo+example.org"
    employee.valid?
    employee.errors.keys.should include(:primary_email_address)
  end

  it "cannot update an invalid model" do
    employee = Quickbooks::Model::Employee.new
    employee.valid_for_update?.should == false
    employee.to_xml_ns.should match('Employee')
    employee.errors.keys.should include(:sync_token)
  end

end
