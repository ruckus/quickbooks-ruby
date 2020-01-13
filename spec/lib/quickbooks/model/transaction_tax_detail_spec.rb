describe "Quickbooks::Model::TransactionTaxDetail" do
  it "allows setting of the TxnTaxCodeRef via #txn_tax_code_ref_id=" do
    transaction_tax_detail = Quickbooks::Model::TransactionTaxDetail.new
    transaction_tax_detail.total_tax = 42
    transaction_tax_detail.txn_tax_code_id = 42
    expect(transaction_tax_detail.txn_tax_code_ref.value).to eq(42)
  end

  it "total tax should be a decimal/float" do
    transaction_tax_detail = Quickbooks::Model::TransactionTaxDetail.new
    transaction_tax_detail.total_tax = 42
    expect(transaction_tax_detail.to_xml.at_css('TotalTax').content).to eq('42.0')
  end

  it "total tax should not be included if not set" do
    transaction_tax_detail = Quickbooks::Model::TransactionTaxDetail.new
    expect(transaction_tax_detail.to_xml).not_to match(/TotalTax/)
  end
end
