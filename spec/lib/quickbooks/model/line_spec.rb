describe "Quickbooks::Model::Line" do
  it "#invoice_id= sets up a linked transaction with the right ID" do
    line = Quickbooks::Model::Line.new

    line.invoice_id = 42

    line.linked_transaction.txn_id.should eq(42)
    line.linked_transaction.txn_type.should eq("Invoice")
  end
end
