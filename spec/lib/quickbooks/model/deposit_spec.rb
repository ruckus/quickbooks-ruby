describe "Quickbooks::Model::Deposit" do
  it "parses from XML" do
    xml = fixture("deposit.xml")
    deposit = Quickbooks::Model::Deposit.from_xml(xml)

    deposit.id.should eq(155)
    deposit.sync_token.should eq(0)
    deposit.meta_data.create_time.
      should eq(Time.new(2015, 3, 7, 11, 30, 04, "-07:00"))
    deposit.meta_data.last_updated_time.
      should eq(Time.new(2015, 3, 7, 11, 30, 04, "-07:00"))
    deposit.txn_date.should eq(Date.new(2015, 3, 7))
    deposit.private_note.should eq("Deposit smoke test")
    deposit.txn_status.should be_nil
    deposit.line_items.size.should == 2
    deposit.deposit_to_account_ref.value.should eq("4")
    deposit.total.should eq(200.0)
    deposit.currency_ref.value.should == 'USD'
    deposit.exchange_rate.should be_nil
    deposit.line_items[1].deposit_line_detail.entity_ref.type.should == 'CUSTOMER'
    deposit.line_items[1].deposit_line_detail.entity_ref.name.should == 'Nicole Tang'
    deposit.line_items[1].deposit_line_detail.entity_ref.value.should == '58'

    line_item1 = deposit.line_items[0]
    line_item1.id.should be_nil
    line_item1.amount.should == 262.0
    line_item1.linked_transactions.size.should == 1
    line_item1.linked_transactions[0].txn_id.should == "154"
    line_item1.linked_transactions[0].txn_type.should == 'Payment'

    line_item2 = deposit.line_items[1]
    line_item2.id.should == "1"
    line_item2.amount.should == -62.50
    line_item2.deposit_line_detail?.should == true
    line_item2.deposit_line_detail.account_ref.value.should == "31"
    line_item2.deposit_line_detail.account_ref.name.should == "Uncategorized Expense"
    line_item2.deposit_line_detail.payment_method_ref.value.should == "1"
    line_item2.deposit_line_detail.payment_method_ref.name.should == "Cash"
  end

  it "should require at least one line" do
    deposit = Quickbooks::Model::Deposit.new
    deposit.should_not be_valid
  end

  it "is valid with at least one line" do
    deposit = Quickbooks::Model::Deposit.new
    deposit.should_not be_valid

    deposit.line_items << Quickbooks::Model::DepositLineItem.new

    deposit.should be_valid
  end

end
