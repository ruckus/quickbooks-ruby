describe Quickbooks::Model::TransactionTaxDetail do
  subject(:transaction_tax_detail) { Quickbooks::Model::TransactionTaxDetail.new }

  describe 'txn_tax_code_ref_id' do
    it "allows setting of the TxnTaxCodeRef via #txn_tax_code_ref_id=" do
      transaction_tax_detail.total_tax = 42
      transaction_tax_detail.txn_tax_code_id = 42
      expect(transaction_tax_detail.txn_tax_code_ref.value).to eq(42)
    end
  end

  describe 'total tax specified' do
    context 'when it is set' do
      before { transaction_tax_detail.total_tax_specified = false }

      it { expect(transaction_tax_detail.to_xml.at_css('TotalTaxSpecified').content).to match('false') }
    end

    context 'when it is not set' do
      it { expect(transaction_tax_detail.to_xml).not_to match(/TotalTaxSpecified/) }
    end
  end

  describe 'total tax' do
    context 'when it is set' do
      before { transaction_tax_detail.total_tax = 42 }

      it { expect(transaction_tax_detail.to_xml.at_css('TotalTax').content).to eq('42.0') }
    end

    context 'when it is not set' do
      it { expect(transaction_tax_detail.to_xml).not_to match(/TotalTax/) }
    end
  end
end
