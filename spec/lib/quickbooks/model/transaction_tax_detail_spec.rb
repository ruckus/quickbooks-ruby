describe "Quickbooks::Model::TransactionTaxDetail" do
  it "allows setting of the TxnTaxCodeRef via #txn_tax_code_ref_id=" do
    transaction_tax_detail = Quickbooks::Model::TransactionTaxDetail.new
    transaction_tax_detail.txn_tax_code_id = 42
    transaction_tax_detail.txn_tax_code_ref.value.should == 42
  end
end
