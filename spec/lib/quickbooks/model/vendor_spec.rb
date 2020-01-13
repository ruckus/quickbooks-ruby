describe "Quickbooks::Model::Vendor" do

  it "parse from XML" do
    xml = fixture("vendor.xml")
    vendor = Quickbooks::Model::Vendor.from_xml(xml)
    expect(vendor.sync_token).to eq(0)
    expect(vendor.title).to eq('Mr.')
    expect(vendor.given_name).to eq('John-MbRSxOmFXk')
    expect(vendor.middle_name).to eq('S.')
    expect(vendor.family_name).to eq('Vendor')
    expect(vendor.suffix).to eq('Jr.')
    expect(vendor.company_name).to eq('John Vendor Company')
    expect(vendor.display_name).to eq('John Vendor-UudRGTA2p7')
    expect(vendor.print_on_check_name).to eq('John Vendor on Check')
    expect(vendor.active?).to eq(true)
    expect(vendor.primary_phone.free_form_number).to eq('(214) 387-2000')
    expect(vendor.alternate_phone.free_form_number).to eq('Tom A')
    expect(vendor.mobile_phone.free_form_number).to eq('(214) 387-2001')
    expect(vendor.fax_phone.free_form_number).to eq('(214) 387-2003')
    expect(vendor.web_site.uri).to eq('http://www.intuit.com')
    expect(vendor.primary_phone).not_to be_nil
    expect(vendor.primary_email_address).not_to be_nil
    expect(vendor.primary_email_address.address).to eq('john.vendor@intuit.com')
    expect(vendor.billing_address).not_to be_nil
    expect(vendor.billing_address.id).to eq("76")
    expect(vendor.billing_address.line1).to eq("1000 Main Street")
    expect(vendor.billing_address.city).to eq("New York")
    expect(vendor.billing_address.country).to eq("United States")
    expect(vendor.billing_address.country_sub_division_code).to eq("NY")
    expect(vendor.billing_address.lat).to eq("40.76864399999999")
    expect(vendor.billing_address.lon).to eq("-73.94270329999999")
    expect(vendor.other_contact_info.type).to eq('TelephoneNumber')
    expect(vendor.other_contact_info.telephone.free_form_number).to eq('(214) 387-2008')
    expect(vendor.tax_identifier).to eq('12-3456789')
    expect(vendor.balance).to eq(0)
    expect(vendor.is_1099?).to be true
  end

  it "can assign an email address" do
    vendor = Quickbooks::Model::Vendor.new
    the_email = "foo@example.org"
    vendor.email_address = the_email
    expect(vendor.email_address.is_a?(Quickbooks::Model::EmailAddress)).to eq(true)
    expect(vendor.email_address.address).to eq(the_email)
  end

  it "can't assign a bad email address" do
    vendor = Quickbooks::Model::Vendor.new
    vendor.email_address = "foo+example.org"
    vendor.valid?
    expect(vendor.errors.keys).to include(:primary_email_address)
  end

  it "cannot update an invalid model" do
    vendor = Quickbooks::Model::Vendor.new
    expect(vendor.valid_for_update?).to eq(false)
    expect(vendor.to_xml_ns).to match('Vendor')
    expect(vendor.errors.keys).to include(:sync_token)
  end

end
