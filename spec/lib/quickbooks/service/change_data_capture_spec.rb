describe "Quickbooks::Service::ChangeDataCapture" do
  let(:service) { construct_service :change_data_capture }
  let(:entities) { ["Bill", "BillPayment", "CreditMemo", "Deposit", "Invoice",
   "JournalEntry", "Payment", "Purchase", "RefundReceipt",
   "SalesReceipt", "PurchaseOrder", "VendorCredit", "Transfer",
   "Estimate", "Account", "Budget", "Class",
   "Customer", "Department", "Employee", "Item",
   "PaymentMethod", "Term", "Vendor"] }

  it "can query for a range of entities at once" do
    xml = fixture("change_data_capture_response.xml")
    model = Quickbooks::Model::ChangeDataCapture

    date = Date.today
    since = "changedSince=#{URI.encode_www_form_component(Date.today.iso8601)}"
    url = service.url_for_query(entities, since)
    stub_http_request(:get, url, ["200", "OK"], xml)
    response = service.since(entities, Date.today)
    response.all_types["Bill"].count.should == 2
    response.all_types["BillPayment"].count.should == 2
    response.all_types["Deposit"].count.should == 1
    response.all_types["Invoice"].count.should == 2
    response.all_types["Payment"].count.should == 1
  end

  describe "#url_for_query" do
    it "builds a query from a list of invoices and a 'since' date" do
      date = Date.today
      since = "changedSince=#{URI.encode_www_form_component(date)}"
      service.url_for_query(entities, since).should == "https://quickbooks.api.intuit.com/v3/company/9991111222/cdc?entities=Bill,BillPayment,CreditMemo,Deposit,Invoice,JournalEntry,Payment,Purchase,RefundReceipt,SalesReceipt,PurchaseOrder,VendorCredit,Transfer,Estimate,Account,Budget,Class,Customer,Department,Employee,Item,PaymentMethod,Term,Vendor&changedSince=#{date.to_s}"
    end
  end

end
