describe "Quickbooks::Model::Customer" do

  it "parse from XML" do
    xml = fixture("customer.xml")
    customer = Quickbooks::Model::Customer.from_xml(xml)
    customer.sync_token.should == 1
    customer.company_name.should == "Thrifty Meats"
    customer.given_name.should == "John"
    customer.family_name.should == "Doe"
    customer.fully_qualified_name.should == "Thrifty Meats"
    customer.print_on_check_name.should == "Thrifty Meats"
    customer.active?.should == true
    customer.primary_phone.should_not be_nil
    customer.primary_phone.free_form_number.should == "(415) 555-1212"
    customer.primary_email_address.should_not be_nil
    customer.primary_email_address.address.should == "info@thriftymeats.com"
    customer.taxable?.should == false
    customer.default_tax_code_ref.to_s.should == 'NON'

    customer.billing_address.should_not be_nil
    customer.billing_address.id.should == 2
    customer.billing_address.line1.should == "123 Swift St."
    customer.billing_address.city.should == "Santa Cruz"
    customer.billing_address.country.should == "USA"
    customer.billing_address.country_sub_division_code.should == "CA"
    customer.billing_address.lat.should == "36.9507991"
    customer.billing_address.lon.should == "-122.0477003"

    customer.shipping_address.should_not be_nil
    customer.shipping_address.id.should == 2
    customer.shipping_address.line1.should == "123 Swift St."
    customer.shipping_address.city.should == "Santa Cruz"
    customer.shipping_address.country.should == "USA"
    customer.shipping_address.country_sub_division_code.should == "CA"
    customer.shipping_address.lat.should == "36.9507991"
    customer.shipping_address.lon.should == "-122.0477003"

    customer.job?.should == false
    customer.bill_with_parent?.should == false
    customer.balance.should == 0
    customer.balance_with_jobs.should == 0
    customer.preferred_delivery_method.should == "Email"

    customer.currency_ref.name.should == "British Pound Sterling"
    customer.currency_ref.value.should == "GBP"
  end

  it "can assign an email address" do
    customer = Quickbooks::Model::Customer.new
    the_email = "foo@example.org"
    customer.email_address = the_email
    customer.email_address.is_a?(Quickbooks::Model::EmailAddress).should == true
    customer.email_address.address.should == the_email
  end

  it "cannot update an invalid model" do
    customer = Quickbooks::Model::Customer.new
    customer.valid_for_update?.should == false
    customer.to_xml_ns.should match('Customer')
    customer.errors.keys.include?(:sync_token).should == true
  end

end
