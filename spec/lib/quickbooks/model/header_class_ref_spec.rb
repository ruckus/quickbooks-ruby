describe "Quickbooks::Model header ClassRef" do
  it "parses header ClassRef on Bill" do
    bill = Quickbooks::Model::Bill.from_xml(fixture("bill_with_header_class_ref.xml"))
    expect(bill.class_ref.value).to eq "qb-class-owner"
    expect(bill.class_ref.name).to eq "Owner"
  end

  it "parses header ClassRef on BillPayment" do
    bill_payment = Quickbooks::Model::BillPayment.from_xml(fixture("bill_payment_with_header_class_ref.xml"))
    expect(bill_payment.class_ref.value).to eq "qb-class-owner"
    expect(bill_payment.class_ref.name).to eq "Owner"
  end

  it "parses header ClassRef on VendorCredit" do
    vendor_credit = Quickbooks::Model::VendorCredit.from_xml(fixture("vendor_credit_with_header_class_ref.xml"))
    expect(vendor_credit.class_ref.value).to eq "qb-class-owner"
    expect(vendor_credit.class_ref.name).to eq "Owner"
  end
end
