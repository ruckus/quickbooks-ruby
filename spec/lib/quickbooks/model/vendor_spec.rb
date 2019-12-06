describe "Quickbooks::Model::Vendor" do

  it "parse from XML" do
    xml = fixture("vendor.xml")
    vendor = Quickbooks::Model::Vendor.from_xml(xml)
    vendor.sync_token.should == 0
    vendor.title.should == 'Mr.'
    vendor.given_name.should == 'John-MbRSxOmFXk'
    vendor.middle_name.should == 'S.'
    vendor.family_name.should == 'Vendor'
    vendor.suffix.should == 'Jr.'
    vendor.company_name.should == 'John Vendor Company'
    vendor.display_name.should == 'John Vendor-UudRGTA2p7'
    vendor.print_on_check_name.should == 'John Vendor on Check'
    vendor.active?.should == true
    vendor.primary_phone.free_form_number.should == '(214) 387-2000'
    vendor.alternate_phone.free_form_number.should == 'Tom A'
    vendor.mobile_phone.free_form_number.should == '(214) 387-2001'
    vendor.fax_phone.free_form_number.should == '(214) 387-2003'
    vendor.web_site.uri.should == 'http://www.intuit.com'
    vendor.primary_phone.should_not be_nil
    vendor.primary_email_address.should_not be_nil
    vendor.primary_email_address.address.should == 'john.vendor@intuit.com'
    vendor.billing_address.should_not be_nil
    vendor.billing_address.id.should == "76"
    vendor.billing_address.line1.should == "1000 Main Street"
    vendor.billing_address.city.should == "New York"
    vendor.billing_address.country.should == "United States"
    vendor.billing_address.country_sub_division_code.should == "NY"
    vendor.billing_address.lat.should == "40.76864399999999"
    vendor.billing_address.lon.should == "-73.94270329999999"
    vendor.other_contact_info.type.should == 'TelephoneNumber'
    vendor.other_contact_info.telephone.free_form_number.should == '(214) 387-2008'
    vendor.tax_identifier.should == '12-3456789'
    vendor.balance.should == 0
    vendor.is_1099?.should be true
  end

  it "can assign an email address" do
    vendor = Quickbooks::Model::Vendor.new
    the_email = "foo@example.org"
    vendor.email_address = the_email
    vendor.email_address.is_a?(Quickbooks::Model::EmailAddress).should == true
    vendor.email_address.address.should == the_email
  end

  it "can't assign a bad email address" do
    vendor = Quickbooks::Model::Vendor.new
    vendor.email_address = "foo+example.org"
    vendor.valid?
    vendor.errors.keys.should include(:primary_email_address)
  end

  it "cannot update an invalid model" do
    vendor = Quickbooks::Model::Vendor.new
    vendor.valid_for_update?.should == false
    vendor.to_xml_ns.should match('Vendor')
    vendor.errors.keys.should include(:sync_token)
  end

end
