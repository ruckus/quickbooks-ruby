describe "Quickbooks::Model::Deposit" do
  it "parses from XML" do
    xml = fixture("deposit.xml")
    deposit = Quickbooks::Model::Deposit.from_xml(xml)

    expect(deposit.id).to eq(155)
    expect(deposit.sync_token).to eq(0)
    expect(deposit.meta_data.create_time).
      to eq(Time.new(2015, 3, 7, 11, 30, 04, "-07:00"))
    expect(deposit.meta_data.last_updated_time).
      to eq(Time.new(2015, 3, 7, 11, 30, 04, "-07:00"))
    expect(deposit.txn_date).to eq(Date.new(2015, 3, 7))
    expect(deposit.private_note).to eq("Deposit smoke test")
    expect(deposit.txn_status).to be_nil
    expect(deposit.line_items.size).to eq(2)
    expect(deposit.deposit_to_account_ref.value).to eq("4")
    expect(deposit.total).to eq(200.0)
    expect(deposit.currency_ref.value).to eq('USD')
    expect(deposit.exchange_rate).to be_nil
    expect(deposit.line_items[1].deposit_line_detail.entity_ref.type).to eq('CUSTOMER')
    expect(deposit.line_items[1].deposit_line_detail.entity_ref.name).to eq('Nicole Tang')
    expect(deposit.line_items[1].deposit_line_detail.entity_ref.value).to eq('58')

    line_item1 = deposit.line_items[0]
    expect(line_item1.id).to be_nil
    expect(line_item1.amount).to eq(262.0)
    expect(line_item1.linked_transactions.size).to eq(1)
    expect(line_item1.linked_transactions[0].txn_id).to eq("154")
    expect(line_item1.linked_transactions[0].txn_type).to eq('Payment')

    line_item2 = deposit.line_items[1]
    expect(line_item2.id).to eq("1")
    expect(line_item2.amount).to eq(-62.50)
    expect(line_item2.deposit_line_detail?).to eq(true)
    expect(line_item2.deposit_line_detail.account_ref.value).to eq("31")
    expect(line_item2.deposit_line_detail.account_ref.name).to eq("Uncategorized Expense")
    expect(line_item2.deposit_line_detail.payment_method_ref.value).to eq("1")
    expect(line_item2.deposit_line_detail.payment_method_ref.name).to eq("Cash")
  end

  it "should require at least one line" do
    deposit = Quickbooks::Model::Deposit.new
    expect(deposit).not_to be_valid
  end

  it "is valid with at least one line" do
    deposit = Quickbooks::Model::Deposit.new
    expect(deposit).not_to be_valid

    deposit.line_items << Quickbooks::Model::DepositLineItem.new

    expect(deposit).to be_valid
  end

end
