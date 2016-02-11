describe "Quickbooks::Model::Transfer" do
  it "parse from XML" do
    xml = fixture("transfer.xml")
    transfer = Quickbooks::Model::Transfer.from_xml(xml)
    transfer.id.should == "148"
    transfer.sync_token.should == 0

    transfer.meta_data.should_not be_nil
    transfer.meta_data.create_time.should == DateTime.parse("2016-02-11T06:00:44-08:00")
    transfer.meta_data.last_updated_time.should == DateTime.parse("2016-02-11T06:00:44-08:00")
    transfer.txn_date.should == Time.parse("2016-02-11")
    transfer.currency_ref.name.should == "United States Dollar"
    transfer.currency_ref.value.should == "USD"
    transfer.private_note.should == "Important notes to explain this transaction"
    transfer.from_account.name.should == "Savings"
    transfer.from_account.value.should == "36"
    transfer.to_account.name.should == "Checking"
    transfer.to_account.value.should == "35"
    transfer.amount.should == 250.00
  end
end