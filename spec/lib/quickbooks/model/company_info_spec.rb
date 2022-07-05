describe "Quickbooks::Model::CompanyInfo" do
  it "parse from XML" do
    xml = fixture("company_info.xml")
    company_info = Quickbooks::Model::CompanyInfo.from_xml(xml)
    expect(company_info.id).to eq("1")
    expect(company_info.sync_token).to eq(3)

    expect(company_info.meta_data).not_to be_nil
    expect(company_info.meta_data.create_time).to eq(DateTime.parse("2013-04-20T10:32:18-07:00"))
    expect(company_info.meta_data.last_updated_time).to eq(DateTime.parse("2013-07-11T08:27:06-07:00"))

    expect(company_info.company_name).to eq("Acme Corp.")
    expect(company_info.legal_name).to eq("Acme Legal Corp.")

    expect(company_info.company_address).not_to be_nil
    expect(company_info.company_address.id).to eq("1")
    expect(company_info.company_address.line1).to eq("Acme Something Street")
    expect(company_info.company_address.line2).to eq("Apartment Acme")
    expect(company_info.company_address.city).to eq("Sunnyvale Acme")
    expect(company_info.company_address.country).to eq("USA")
    expect(company_info.company_address.postal_code).to eq("94085")
    expect(company_info.company_address.lat).to eq("37.3895297")
    expect(company_info.company_address.lon).to eq("-122.0183914")

    expect(company_info.customer_communication_address).not_to be_nil
    expect(company_info.customer_communication_address.id).to eq("55")
    expect(company_info.customer_communication_address.line1).to eq("Acme Something Street Customer Comm")
    expect(company_info.customer_communication_address.line2).to eq("Apartment Acme")
    expect(company_info.customer_communication_address.city).to eq("Sunnyvale Acme")
    expect(company_info.customer_communication_address.country).to eq("USA")
    expect(company_info.customer_communication_address.postal_code).to eq("94085")
    expect(company_info.customer_communication_address.lat).to eq("37.3895297")
    expect(company_info.customer_communication_address.lon).to eq("-122.0183914")

    expect(company_info.legal_address).not_to be_nil
    expect(company_info.legal_address.id).to eq("54")
    expect(company_info.legal_address.line1).to eq("Acme Something Street Legal")
    expect(company_info.legal_address.line2).to eq("Apartment Acme")
    expect(company_info.legal_address.city).to eq("Sunnyvale Acme")
    expect(company_info.legal_address.country).to eq("USA")
    expect(company_info.legal_address.postal_code).to eq("94085")
    expect(company_info.legal_address.lat).to eq("37.3895297")
    expect(company_info.legal_address.lon).to eq("-122.0183914")

    expect(company_info.primary_phone).not_to be_nil
    expect(company_info.primary_phone.free_form_number).to eq("6192098978")

    expect(company_info.company_start_date).to eq(DateTime.parse("2013-04-20"))
    expect(company_info.country).to eq("US")

    expect(company_info.email).not_to be_nil
    expect(company_info.email.address).to eq("acme@enterprise.com")

    expect(company_info.web_site).not_to be_nil
    expect(company_info.web_site.uri).to eq("http://www.acmeenterprise.com")

    expect(company_info.supported_languages).to eq("en")

    expect(company_info.name_values.count).to eq(8)

    expect(company_info.industry_type).to eq("Restaurant, Caterer, or Bar")
    expect(company_info.industry_code).to eq("722")
    expect(company_info.company_type).to eq("SCorporation")
    expect(company_info.subscription_status).to eq("TRIAL")
    expect(company_info.offering_sku).to eq("QuickBooks Online Essentials")
    expect(company_info.neo_enabled).to be false
    expect(company_info.payroll_feature).to be false
    expect(company_info.accountant_feature).to be false

    expect(company_info.find_name_value('Missing')).to be_nil
  end
end
