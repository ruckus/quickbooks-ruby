describe "Quickbooks::Model::Preferences" do
  it "should parse from XML" do
    xml = fixture("preferences.xml")
    preferences = Quickbooks::Model::Preferences.from_xml(xml)

    expect(preferences.accounting_info.customer_terminology).to eq("Customers")
    expect(preferences.currency.home_currency).to eq("USD")

    expect(preferences.tax.using_sales_tax?).to be false
    expect(preferences.tax.partner_tax_enabled?).to be false
    expect(preferences.time_tracking.bill_customers?).to be true

    expect(preferences.email_messages.invoice_message.subject).to eq("Invoice from Demo Company")
    expect(preferences.email_messages.estimate_message.message).to include("We look forward to working with you.")

    expect(preferences.sales_forms.auto_apply_credit?).to be true
    expect(preferences.sales_forms.custom_fields).not_to be_empty
    expect(preferences.sales_forms.custom_fields[0].name).to eq("SalesFormsPrefs.UseSalesCustom1")
    expect(preferences.sales_forms.custom_fields[3].name).to eq("SalesFormsPrefs.SalesCustomName1")

    expect(preferences.other_prefs["SalesFormsPrefs.DefaultItem"]).to eq("1")
  end
end
