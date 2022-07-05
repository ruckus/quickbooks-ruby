describe "Quickbooks::Model::Bill" do

  it "parse from XML" do
    xml = fixture("bill_create_response.xml")
    bill = Quickbooks::Model::Bill.from_xml(xml)
    expect(bill.sync_token).to eq 0
    expect(bill.txn_date.to_date).to eq Date.civil(2017,12,16)
    expect(bill.due_date.to_date).to eq Date.civil(2018,12,26)
    expect(bill.total).to eq 755.12

    expect(bill.vendor_ref.value).to eq "4"
    expect(bill.vendor_ref.name).to eq "Great Statewide Bank"

    expect(bill.line_items.size).to eq 2

    line_item1 = bill.line_items[0]
    expect(line_item1.id).to eq "1"
    expect(line_item1.amount).to eq 700.0
    expect(line_item1.account_based_expense_item?).to eq true
    expect(line_item1.account_based_expense_line_detail.account_ref.value).to eq "42"
    expect(line_item1.account_based_expense_line_detail.account_ref.name).to eq "Bank Loan"
    expect(line_item1.account_based_expense_line_detail.billable_status).to eq "NotBillable"
    expect(line_item1.account_based_expense_line_detail.class_ref.value).to eq "100000000000128320"
    expect(line_item1.account_based_expense_line_detail.class_ref.name).to eq "Overhead"
    expect(line_item1.account_based_expense_line_detail.tax_code_ref.to_s).to eq "NON"

    line_item2 = bill.line_items[1]
    expect(line_item2.id).to eq "2"
    expect(line_item2.amount).to eq 55.12
    expect(line_item2.account_based_expense_item?).to eq true
    expect(line_item2.account_based_expense_line_detail.account_ref.value).to eq "77"
    expect(line_item2.account_based_expense_line_detail.account_ref.name).to eq "Interest Expense"
    expect(line_item2.account_based_expense_line_detail.billable_status).to eq "NotBillable"
    expect(line_item2.account_based_expense_line_detail.class_ref.value).to eq "100000000000128320"
    expect(line_item2.account_based_expense_line_detail.class_ref.name).to eq "Overhead"
    expect(line_item2.account_based_expense_line_detail.tax_code_ref.to_s).to eq "NON"
  end

  it "can parse an Item-based bill from XML" do
    xml = fixture("bill_line_item_expense.xml")
    bill = Quickbooks::Model::Bill.from_xml(xml)
    line_item1 = bill.line_items[0]
    expect(line_item1.item_based_expense_item?).to eq true
  end

  it "can parse a bill with LinkedTxn from XML" do
    xml = fixture("bill_linked_transactions.xml")
    bill = Quickbooks::Model::Bill.from_xml(xml)
    expect(bill.linked_transactions.size).to eq 1
    linked_txn1 = bill.linked_transactions[0]
    expect(linked_txn1.bill_payment_check_type?).to eq true
  end

  it "can parse a bill with TxnTaxDetail from XML" do
    xml = fixture("bill_txn_tax_detail.xml")
    bill = Quickbooks::Model::Bill.from_xml(xml)
    txn_tax_detail = bill.txn_tax_detail
    expect(txn_tax_detail.total_tax).to eq(20)

    tax_line = txn_tax_detail.lines.first
    expect(tax_line.amount).to eq(20)
    expect(tax_line.detail_type).to eq("TaxLineDetail")
    expect(tax_line.tax_line_detail.tax_rate_ref.value).to eq("17")
    expect(tax_line.tax_line_detail.percent_based?).to be true
    expect(tax_line.tax_line_detail.tax_percent).to eq(5)
    expect(tax_line.tax_line_detail.net_amount_taxable).to eq(400)
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
