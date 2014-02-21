describe "Quickbooks::Model::Payment" do
  it "parses from XML" do
    xml = fixture("payment.xml")
    payment = Quickbooks::Model::Payment.from_xml(xml)

    payment.id.should eq(8748)
    payment.sync_token.should eq(0)
    payment.meta_data.create_time.
      should eq(Time.new(2013, 7, 11, 17, 51, 41, "-07:00"))
    payment.meta_data.last_updated_time.
      should eq(Time.new(2013, 7, 11, 17, 51, 42, "-07:00"))
    payment.txn_date.should eq(Date.new(2013, 7, 11))
    payment.private_note.should eq("Payment smoke test")
    payment.txn_status.should be_nil
    payment.line_items.size.should == 0
    payment.customer_ref.value.should eq("25342")
    payment.deposit_to_account_ref.value.should eq("4")
    payment.total.should eq(40.0)
    payment.unapplied_amount.should eq(40.0)
    payment.process_payment.should eq("false")
    payment.currency_ref.should be_nil
    payment.exchange_rate.should be_nil
  end

  it "should require customer_ref for create / update" do
    invoice = Quickbooks::Model::Payment.new
    invoice.should_not be_valid
    invoice.errors.keys.include?(:customer_ref).should be_true
  end

  it "is valid with customer_ref" do
    invoice = Quickbooks::Model::Payment.new
    invoice.customer_id = 2

    invoice.should be_valid
  end

end
