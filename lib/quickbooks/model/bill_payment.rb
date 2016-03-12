module Quickbooks
  module Model
    class BillPayment < BaseModel
      include HasLineItems

      XML_COLLECTION_NODE = "BillPayment"
      XML_NODE = "BillPayment"
      REST_RESOURCE = 'billpayment'

      xml_accessor :id, :from => 'Id'
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :doc_number, :from => 'DocNumber'
      xml_accessor :txn_date, :from => 'TxnDate', :as => Date

      xml_accessor :line_items, :from => 'Line', :as => [BillPaymentLineItem]

      xml_accessor :private_note, :from => 'PrivateNote'

      xml_accessor :vendor_ref, :from => 'VendorRef', :as => BaseReference
      xml_accessor :department_ref, :from => 'DepartmentRef', :as => BaseReference
      xml_accessor :currency_ref, :from => 'CurrencyRef', :as => BaseReference
      xml_accessor :exchange_rate, :from => 'ExchangeRate', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :ap_account_ref, :from => 'APAccountRef', :as => BaseReference
      xml_accessor :pay_type, :from => 'PayType'
      xml_accessor :process_bill_payment?, :from => 'ProcessBillPayment'

      ## Required if PayType is Check.
      xml_accessor :check_payment, :from => 'CheckPayment', :as => BillPaymentCheck
      ## Required if PayType is CreditCard.
      xml_accessor :credit_card_payment, :from => 'CreditCardPayment', :as => BillPaymentCreditCard

      xml_accessor :total, :from => 'TotalAmt', :as => BigDecimal

      validate :line_item_size

      reference_setters
    end
  end
end
