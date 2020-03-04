describe "Quickbooks::Model::Customer" do

  it "parse from XML" do
    xml = fixture("customer.xml")
    customer = Quickbooks::Model::Customer.from_xml(xml)
    expect(customer.sync_token).to eq(1)
    expect(customer.company_name).to eq("Thrifty Meats")
    expect(customer.given_name).to eq("John")
    expect(customer.family_name).to eq("Doe")
    expect(customer.fully_qualified_name).to eq("Thrifty Meats")
    expect(customer.print_on_check_name).to eq("Thrifty Meats")
    expect(customer.active?).to eq(true)
    expect(customer.primary_phone).not_to be_nil
    expect(customer.primary_phone.free_form_number).to eq("(415) 555-1212")
    expect(customer.primary_email_address).not_to be_nil
    expect(customer.primary_email_address.address).to eq("info@thriftymeats.com")
    expect(customer.taxable?).to eq(false)
    expect(customer.default_tax_code_ref.to_s).to eq('NON')

    expect(customer.billing_address).not_to be_nil
    expect(customer.billing_address.id).to eq("2")
    expect(customer.billing_address.line1).to eq("123 Swift St.")
    expect(customer.billing_address.city).to eq("Santa Cruz")
    expect(customer.billing_address.country).to eq("USA")
    expect(customer.billing_address.country_sub_division_code).to eq("CA")
    expect(customer.billing_address.lat).to eq("36.9507991")
    expect(customer.billing_address.lon).to eq("-122.0477003")

    expect(customer.shipping_address).not_to be_nil
    expect(customer.shipping_address.id).to eq("2")
    expect(customer.shipping_address.line1).to eq("123 Swift St.")
    expect(customer.shipping_address.city).to eq("Santa Cruz")
    expect(customer.shipping_address.country).to eq("USA")
    expect(customer.shipping_address.country_sub_division_code).to eq("CA")
    expect(customer.shipping_address.lat).to eq("36.9507991")
    expect(customer.shipping_address.lon).to eq("-122.0477003")

    expect(customer.job?).to eq(false)
    expect(customer.bill_with_parent?).to eq(false)
    expect(customer.balance).to eq(0)
    expect(customer.balance_with_jobs).to eq(0)
    expect(customer.preferred_delivery_method).to eq("Email")

    expect(customer.currency_ref.name).to eq("British Pound Sterling")
    expect(customer.currency_ref.value).to eq("GBP")
    expect(customer.customer_type_ref.value).to eq("5000000000000000185")
  end

  it "can assign an email address" do
    customer = Quickbooks::Model::Customer.new
    the_email = "foo@example.org"
    customer.email_address = the_email
    expect(customer.email_address.is_a?(Quickbooks::Model::EmailAddress)).to eq(true)
    expect(customer.email_address.address).to eq(the_email)
  end

  it "cannot update an invalid model" do
    customer = Quickbooks::Model::Customer.new
    expect(customer.valid_for_update?).to eq(false)
    expect(customer.to_xml_ns).to match('Customer')
    expect(customer.errors.keys.include?(:sync_token)).to eq(true)
  end

  it "should handle a nil/blank email address" do
    customer = Quickbooks::Model::Customer.new
    email = Quickbooks::Model::EmailAddress.new
    email.address = nil
    customer.email_address = email
    expect(customer.valid?).to eq(false)
  end

end
