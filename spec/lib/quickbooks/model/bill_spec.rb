describe "Quickbooks::Model::Bill" do

  it "parse from XML" do
    xml = fixture("bill_create_response.xml")
    bill = Quickbooks::Model::Bill.from_xml(xml)
    bill.sync_token.should == 0
    bill.txn_date.to_date.should == Date.civil(2017,12,16)
    bill.due_date.to_date.should == Date.civil(2018,12,26)
    bill.total.should == 755.12

    bill.vendor_ref.value.should == "4"
    bill.vendor_ref.name.should == "Great Statewide Bank"

    bill.line_items.size.should == 2
    
    line_item1 = bill.line_items[0]
    line_item1.id.should == 1
    line_item1.amount.should == 700.0
    line_item1.account_based_expense_item?.should == true
    line_item1.account_based_expense_line_detail.account_ref.value.should == "42"
    line_item1.account_based_expense_line_detail.account_ref.name.should == "Bank Loan"
    line_item1.account_based_expense_line_detail.billable_status.should == "NotBillable"
    line_item1.account_based_expense_line_detail.class_ref.value.should == "100000000000128320"
    line_item1.account_based_expense_line_detail.class_ref.name.should == "Overhead"
    line_item1.account_based_expense_line_detail.tax_code_ref.should == "NON"

    line_item2 = bill.line_items[1]
    line_item2.id.should == 2
    line_item2.amount.should == 55.12
    line_item2.account_based_expense_item?.should == true
    line_item2.account_based_expense_line_detail.account_ref.value.should == "77"
    line_item2.account_based_expense_line_detail.account_ref.name.should == "Interest Expense"
    line_item2.account_based_expense_line_detail.billable_status.should == "NotBillable"
    line_item2.account_based_expense_line_detail.class_ref.value.should == "100000000000128320"
    line_item2.account_based_expense_line_detail.class_ref.name.should == "Overhead"
    line_item2.account_based_expense_line_detail.tax_code_ref.should == "NON"
  end

end
