describe "Quickbooks::Model::Preferences" do
  it "should parse from XML" do
    xml = fixture("preferences.xml")
    preferences = Quickbooks::Model::Preferences.from_xml(xml)

    preferences.accounting_info.customer_terminology.should == "Customers"
    preferences.currency.home_currency.should == "USD"

    preferences.tax.using_sales_tax?.should be_false
    preferences.time_tracking.bill_customers?.should be_true

    preferences.email_messages.invoice_message.subject.should == "Invoice from Demo Company"
    preferences.email_messages.estimate_message.message.should include("We look forward to working with you.")

    preferences.other_prefs["SalesFormsPrefs.DefaultItem"].should == "1"
  end
end
