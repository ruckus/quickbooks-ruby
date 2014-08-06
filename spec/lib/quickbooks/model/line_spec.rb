describe Quickbooks::Model::Line do
  context "#linked_transactions" do
    shared_examples_for 'assign single linked transaction id' do
      let(:id)     { 1 }
      let(:new_id) { 2 }

      before do
        subject.send(:"#{type.underscore}_id=", id)
      end

      it 'sets up a linked transaction with the right ID' do
        subject.linked_transactions[0].txn_id.should eq(id)
        subject.linked_transactions[0].txn_type.should eq(type)
      end

      it 'updates a linked transaction with a new ID' do
        subject.send(:"#{type.underscore}_id=", new_id)
        subject.linked_transactions[0].txn_id.should eq(new_id)
      end

      it 'can be cleared' do
        subject.send(:"#{type.underscore}_id=", nil)
        subject.linked_transactions.should be_blank
      end
    end

    shared_examples_for 'assign multiple linked transaction ids' do
      let(:ids)     { [1, 2] }
      let(:new_ids) { [3, 4, 5] }

      before do
        subject.send(:"#{type.underscore}_ids=", ids)
      end

      it 'sets up a linked transaction with the right IDs' do
        subject.linked_transactions.map(&:txn_id).should eq(ids)
      end

      it 'updates a linked transaction with a new IDs' do
        subject.send(:"#{type.underscore}_ids=", new_ids)
        subject.linked_transactions.map(&:txn_id).should eq(new_ids)
      end

      it 'can be cleared' do
        subject.send(:"#{type.underscore}_ids=", nil)
        subject.linked_transactions.should be_blank
      end
    end

    context "Invoice" do
      let(:type) { 'Invoice' }

      include_examples 'assign single linked transaction id'
      include_examples 'assign multiple linked transaction ids'
    end

    context "Credit Memo" do
      let(:type) { 'CreditMemo' }

      include_examples 'assign single linked transaction id'
      include_examples 'assign multiple linked transaction ids'
    end

    context "Invoice and Credit Memo" do
      let(:invoice_ids)     { [1, 2] }
      let(:credit_memo_ids) { [3, 4] }

      before do
        subject.invoice_ids = invoice_ids
        subject.credit_memo_ids = credit_memo_ids
      end

      it 'sets up all the linked transactions' do
        subject.linked_transactions.size.should eq(4)
      end

      it 'can clear invoices only' do
        subject.invoice_ids = nil
        subject.linked_transactions.size.should eq(2)
        subject.linked_transactions.count { |lt| lt.txn_type == 'CreditMemo' }.should eq(2)
      end

      it 'can clear credit memos only' do
        subject.credit_memo_ids = nil
        subject.linked_transactions.size.should eq(2)
        subject.linked_transactions.count { |lt| lt.txn_type == 'Invoice' }.should eq(2)
      end
    end

  end
end
