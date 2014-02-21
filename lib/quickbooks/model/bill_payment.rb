module Quickbooks
  module Model
    class BillPayment < BaseModel
      XML_COLLECTION_NODE = "BillPayment"
      XML_NODE = "BillPayment"
      REST_RESOURCE = 'billpayment'

      xml_accessor :id, :from => 'Id', :as => Integer
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :doc_number, :from => 'DocNumber'
      xml_accessor :txn_date, :from => 'TxnDate', :as => Date

      xml_accessor :line_items, :from => 'Line', :as => [BillPaymentLineItem]

      xml_accessor :private_note, :from => 'PrivateNote'

      xml_accessor :vendor_ref, :from => 'VendorRef', :as => BaseReference
      xml_accessor :pay_type, :from => 'PayType'

      ## Required if PayType is Check.
      xml_accessor :check_payment, :from => 'CheckPayment', :as => BillPaymentCheck
      ## Required if PayType is CreditCard.
      xml_accessor :credit_card_payment, :from => 'CreditCardPayment', :as => BillPaymentCreditCard

      # readonly
      xml_accessor :total, :from => 'TotalAmt', :as => BigDecimal

      validates_length_of :line_items, :minimum => 1

      reference_setters :vendor_ref
    end
  end
end
