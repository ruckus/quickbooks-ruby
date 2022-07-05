describe "Quickbooks::Model::Transfer" do
  it "parse from XML" do
    xml = fixture("transfer.xml")
    transfer = Quickbooks::Model::Transfer.from_xml(xml)
    expect(transfer.id).to eq("148")
    expect(transfer.sync_token).to eq(0)

    expect(transfer.meta_data).not_to be_nil
    expect(transfer.meta_data.create_time).to eq(DateTime.parse("2016-02-11T06:00:44-08:00"))
    expect(transfer.meta_data.last_updated_time).to eq(DateTime.parse("2016-02-11T06:00:44-08:00"))
    expect(transfer.txn_date).to eq(Date.civil(2016, 2, 11))
    expect(transfer.currency_ref.name).to eq("United States Dollar")
    expect(transfer.currency_ref.value).to eq("USD")
    expect(transfer.private_note).to eq("Important notes to explain this transaction")
    expect(transfer.from_account_ref.name).to eq("Savings")
    expect(transfer.from_account_ref.value).to eq("36")
    expect(transfer.to_account_ref.name).to eq("Checking")
    expect(transfer.to_account_ref.value).to eq("35")
    expect(transfer.amount).to eq(250.00)
  end
end