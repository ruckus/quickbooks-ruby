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
    line_item1.id.should == "1"
    line_item1.amount.should == 700.0
    line_item1.account_based_expense_item?.should == true
    line_item1.account_based_expense_line_detail.account_ref.value.should == "42"
    line_item1.account_based_expense_line_detail.account_ref.name.should == "Bank Loan"
    line_item1.account_based_expense_line_detail.billable_status.should == "NotBillable"
    line_item1.account_based_expense_line_detail.class_ref.value.should == "100000000000128320"
    line_item1.account_based_expense_line_detail.class_ref.name.should == "Overhead"
    line_item1.account_based_expense_line_detail.tax_code_ref.to_s.should == "NON"

    line_item2 = bill.line_items[1]
    line_item2.id.should == "2"
    line_item2.amount.should == 55.12
    line_item2.account_based_expense_item?.should == true
    line_item2.account_based_expense_line_detail.account_ref.value.should == "77"
    line_item2.account_based_expense_line_detail.account_ref.name.should == "Interest Expense"
    line_item2.account_based_expense_line_detail.billable_status.should == "NotBillable"
    line_item2.account_based_expense_line_detail.class_ref.value.should == "100000000000128320"
    line_item2.account_based_expense_line_detail.class_ref.name.should == "Overhead"
    line_item2.account_based_expense_line_detail.tax_code_ref.to_s.should == "NON"
  end

  it "can parse an Item-based bill from XML" do
    xml = fixture("bill_line_item_expense.xml")
    bill = Quickbooks::Model::Bill.from_xml(xml)
    line_item1 = bill.line_items[0]
    line_item1.item_based_expense_item?.should == true
  end

  it "can parse a bill with LinkedTxn from XML" do
    xml = fixture("bill_linked_transactions.xml")
    bill = Quickbooks::Model::Bill.from_xml(xml)
    bill.linked_transactions.size.should == 1
    linked_txn1 = bill.linked_transactions[0]
    linked_txn1.bill_payment_check_type?.should == true
  end

  describe "#global_tax_calculation" do
    subject { Quickbooks::Model::Bill.new }
    it_should_behave_like "a model with a valid GlobalTaxCalculation", "TaxInclusive"
    it_should_behave_like "a model with a valid GlobalTaxCalculation", "TaxExcluded"
    it_should_behave_like "a model with a valid GlobalTaxCalculation", "NotApplicable"
    it_should_behave_like "a model with a valid GlobalTaxCalculation", ""
    it_should_behave_like "a model with an invalid GlobalTaxCalculation"
  end

end
