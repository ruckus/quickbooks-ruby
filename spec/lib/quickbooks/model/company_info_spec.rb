describe "Quickbooks::Model::CompanyInfo" do
  it "parse from XML" do
    xml = fixture("company_info.xml")
    company_info = Quickbooks::Model::CompanyInfo.from_xml(xml)
    company_info.id.should == 1
    company_info.sync_token.should == 3

    company_info.meta_data.should_not be_nil
    company_info.meta_data.create_time.should == DateTime.parse("2013-04-20T10:32:18-07:00")
    company_info.meta_data.last_updated_time.should == DateTime.parse("2013-07-11T08:27:06-07:00")

    company_info.company_name.should == "Acme Corp."
    company_info.legal_name.should == "Acme Legal Corp."

    company_info.company_address.should_not be_nil
    company_info.company_address.id.should == 1
    company_info.company_address.line1.should == "Acme Something Street"
    company_info.company_address.line2.should == "Apartment Acme"
    company_info.company_address.city.should == "Sunnyvale Acme"
    company_info.company_address.country.should == "USA"
    company_info.company_address.postal_code.should == "94085"
    company_info.company_address.lat.should == "37.3895297"
    company_info.company_address.lon.should == "-122.0183914"

    company_info.customer_communication_address.should_not be_nil
    company_info.customer_communication_address.id.should == 55
    company_info.customer_communication_address.line1.should == "Acme Something Street Customer Comm"
    company_info.customer_communication_address.line2.should == "Apartment Acme"
    company_info.customer_communication_address.city.should == "Sunnyvale Acme"
    company_info.customer_communication_address.country.should == "USA"
    company_info.customer_communication_address.postal_code.should == "94085"
    company_info.customer_communication_address.lat.should == "37.3895297"
    company_info.customer_communication_address.lon.should == "-122.0183914"

    company_info.legal_address.should_not be_nil
    company_info.legal_address.id.should == 54
    company_info.legal_address.line1.should == "Acme Something Street Legal"
    company_info.legal_address.line2.should == "Apartment Acme"
    company_info.legal_address.city.should == "Sunnyvale Acme"
    company_info.legal_address.country.should == "USA"
    company_info.legal_address.postal_code.should == "94085"
    company_info.legal_address.lat.should == "37.3895297"
    company_info.legal_address.lon.should == "-122.0183914"

    company_info.primary_phone.should_not be_nil
    company_info.primary_phone.free_form_number.should == "6192098978"

    company_info.company_start_date.should == DateTime.parse("2013-04-20")
    company_info.country.should == "US"

    company_info.email.should_not be_nil
    company_info.email.address.should == "acme@enterprise.com"

    company_info.web_site.should_not be_nil
    company_info.web_site.uri.should == "http://www.acmeenterprise.com"

    company_info.supported_languages.should == "en"

    company_info.name_values.count.should == 8

    company_info.industry_type.should == "Restaurant, Caterer, or Bar"
    company_info.industry_code.should == "722"
    company_info.company_type.should == "SCorporation"
    company_info.subscription_status.should == "TRIAL"
    company_info.offering_sku.should == "QuickBooks Online Essentials"
    company_info.neo_enabled.should be_false
    company_info.payroll_feature.should be_false
    company_info.accountant_feature.should be_false
  end
end
