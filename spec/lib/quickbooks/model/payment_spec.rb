describe "Quickbooks::Model::Payment" do
  it "parses from XML" do
    xml = fixture("payment.xml")
    payment = Quickbooks::Model::Payment.from_xml(xml)

    expect(payment.id).to eq("8748")
    expect(payment.sync_token).to eq(0)
    expect(payment.meta_data.create_time).to eq(Time.new(2013, 7, 11, 17, 51, 41, "-07:00"))
    expect(payment.meta_data.last_updated_time).to eq(Time.new(2013, 7, 11, 17, 51, 42, "-07:00"))
    expect(payment.txn_date).to eq(Date.new(2013, 7, 11))
    expect(payment.private_note).to eq("Payment smoke test")
    expect(payment.txn_status).to be_nil
    expect(payment.line_items.size).to eq(0)
    expect(payment.customer_ref.value).to eq("25342")
    expect(payment.deposit_to_account_ref.value).to eq("4")
    expect(payment.total).to eq(40.0)
    expect(payment.unapplied_amount).to eq(40.0)
    expect(payment.process_payment).to eq("false")
    expect(payment.currency_ref).to be_nil
    expect(payment.exchange_rate).to be_nil
  end

  it "should require customer_ref for create / update" do
    invoice = Quickbooks::Model::Payment.new
    expect(invoice).not_to be_valid
    expect(invoice.errors.keys.include?(:customer_ref)).to be true
  end

  it "is valid with customer_ref" do
    invoice = Quickbooks::Model::Payment.new
    invoice.customer_id = 2

    expect(invoice).to be_valid
  end

  it "can parse payments with LineExtras" do
    xml = fixture("payment_with_line_extras.xml")
    payment = Quickbooks::Model::Payment.from_xml(xml)
    expect(payment.line_items.size).to eq(1)

    line = payment.line_items[0]
    expect(line.line_extras).not_to be_nil

    extras = line.line_extras.name_values
    expect(extras.size).to eq(3)

    txnReferenceNumber = extras.detect { |a| a.name == "txnReferenceNumber" }
    expect(txnReferenceNumber).not_to be_nil

  end

end
