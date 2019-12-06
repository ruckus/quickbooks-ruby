describe "Quickbooks::Model::BillPayment" do

  it "parse from XML (credit card)" do
    xml = fixture("bill_payment_cc_response.xml")
    bill = Quickbooks::Model::BillPayment.from_xml(xml)
    expect(bill.sync_token).to eq 0
    expect(bill.txn_date.to_date).to eq Date.civil(2013,10,18)
    expect(bill.total).to eq 336.0

    expect(bill.pay_type).to eq "CreditCard"
    expect(bill.credit_card_payment.cc_account_ref.name).to eq "CreditCard"
    expect(bill.credit_card_payment.cc_account_ref.value).to eq "135"

    expect(bill.vendor_ref.value).to eq "38"
    expect(bill.vendor_ref.name).to eq "Nolan Hardware and Supplies"

    expect(bill.line_items.size).to eq 1

    line_item1 = bill.line_items[0]
    expect(line_item1.amount).to eq 336.0
    expect(line_item1.linked_transactions.size).to eq 1

    linked_txn1 = line_item1.linked_transactions[0]
    expect(linked_txn1.txn_type).to eq "Bill"
    expect(linked_txn1.txn_id).to eq "134"
  end

  it "parse from XML (check)" do
    xml = fixture("bill_payment_check_response.xml")
    bill = Quickbooks::Model::BillPayment.from_xml(xml)
    expect(bill.sync_token).to eq 1
    expect(bill.txn_date.to_date).to eq Date.civil(2015,12,15)
    expect(bill.total).to eq 110.0

    expect(bill.pay_type).to eq "Check"
    expect(bill.check_payment.bank_account_ref.name).to eq "Barter Account"
    expect(bill.check_payment.bank_account_ref.value).to eq "133"

    expect(bill.vendor_ref.value).to eq "32"
    expect(bill.vendor_ref.name).to eq "Computer Services by DJ"

    expect(bill.line_items.size).to eq 0
  end
end
