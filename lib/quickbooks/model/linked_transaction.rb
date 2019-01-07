module Quickbooks
  module Model
    class LinkedTransaction < BaseModel
      #== Constants
      DEFAULT_TXN_TYPE = 'BillPaymentCheck'.freeze

      xml_accessor :txn_id, :from => 'TxnId'
      xml_accessor :txn_type, :from => 'TxnType'
      xml_accessor :txn_line_id, :from => 'TxnLineId'

      def bill_payment_check_type?
        txn_type.to_s == DEFAULT_TXN_TYPE
      end
    end
  end
end