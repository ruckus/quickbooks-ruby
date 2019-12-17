describe "Quickbooks::Model::BillPayment" do

  it "parse from XML (credit card)" do
    xml = fixture("bill_payment_cc_response.xml")
    bill = Quickbooks::Model::BillPayment.from_xml(xml)
    bill.sync_token.should == 0
    bill.txn_date.to_date.should == Date.civil(2013,10,18)
    bill.total.should == 336.0

    bill.pay_type.should == "CreditCard"
    bill.credit_card_payment.cc_account_ref.name.should == "CreditCard"
    bill.credit_card_payment.cc_account_ref.value.should == "135"

    bill.vendor_ref.value.should == "38"
    bill.vendor_ref.name.should == "Nolan Hardware and Supplies"

    bill.line_items.size.should == 1

    line_item1 = bill.line_items[0]
    line_item1.amount.should == 336.0
    line_item1.linked_transactions.size.should == 1

    linked_txn1 = line_item1.linked_transactions[0]
    linked_txn1.txn_type.should == "Bill"
    linked_txn1.txn_id.should == "134"
  end

  it "parse from XML (check)" do
    xml = fixture("bill_payment_check_response.xml")
    bill = Quickbooks::Model::BillPayment.from_xml(xml)
    bill.sync_token.should == 1
    bill.txn_date.to_date.should == Date.civil(2015,12,15)
    bill.total.should == 110.0

    bill.pay_type.should == "Check"
    bill.check_payment.bank_account_ref.name.should == "Barter Account"
    bill.check_payment.bank_account_ref.value.should == "133"

    bill.vendor_ref.value.should == "32"
    bill.vendor_ref.name.should == "Computer Services by DJ"

    bill.line_items.size.should == 0
  end
end
