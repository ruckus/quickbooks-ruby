describe Quickbooks::Model::Line do
  context "#linked_transactions" do
    shared_examples_for 'assign single linked transaction id' do
      let(:id)     { 1 }
      let(:new_id) { 2 }

      before do
        subject.send(:"#{type.underscore}_id=", id)
      end

      it 'sets up a linked transaction with the right ID' do
        expect(subject.linked_transactions[0].txn_id).to eq(id)
        expect(subject.linked_transactions[0].txn_type).to eq(type)
      end

      it 'updates a linked transaction with a new ID' do
        subject.send(:"#{type.underscore}_id=", new_id)
        expect(subject.linked_transactions[0].txn_id).to eq(new_id)
      end

      it 'can be cleared' do
        subject.send(:"#{type.underscore}_id=", nil)
        expect(subject.linked_transactions).to be_blank
      end
    end

    shared_examples_for 'assign multiple linked transaction ids' do
      let(:ids)     { [1, 2] }
      let(:new_ids) { [3, 4, 5] }

      before do
        subject.send(:"#{type.underscore}_ids=", ids)
      end

      it 'sets up a linked transaction with the right IDs' do
        expect(subject.linked_transactions.map(&:txn_id)).to eq(ids)
      end

      it 'updates a linked transaction with a new IDs' do
        subject.send(:"#{type.underscore}_ids=", new_ids)
        expect(subject.linked_transactions.map(&:txn_id)).to eq(new_ids)
      end

      it 'can be cleared' do
        subject.send(:"#{type.underscore}_ids=", nil)
        expect(subject.linked_transactions).to be_blank
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
        expect(subject.linked_transactions.size).to eq(4)
      end

      it 'can clear invoices only' do
        subject.invoice_ids = nil
        expect(subject.linked_transactions.size).to eq(2)
        expect(subject.linked_transactions.count { |lt| lt.txn_type == 'CreditMemo' }).to eq(2)
      end

      it 'can clear credit memos only' do
        subject.credit_memo_ids = nil
        expect(subject.linked_transactions.size).to eq(2)
        expect(subject.linked_transactions.count { |lt| lt.txn_type == 'Invoice' }).to eq(2)
      end
    end

  end
end
