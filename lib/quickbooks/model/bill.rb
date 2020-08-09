module Quickbooks
  module Model
    class Bill < BaseModel
      include GlobalTaxCalculation
      include HasLineItems

      XML_COLLECTION_NODE = "Bill"
      XML_NODE = "Bill"
      REST_RESOURCE = 'bill'

      xml_accessor :id, :from => 'Id'
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :doc_number, :from => 'DocNumber'
      xml_accessor :txn_date, :from => 'TxnDate', :as => Date
      xml_accessor :department_ref, :from => 'DepartmentRef', :as => BaseReference

      xml_accessor :line_items, :from => 'Line', :as => [BillLineItem]
      xml_accessor :txn_tax_detail, :from => 'TxnTaxDetail', :as => TransactionTaxDetail

      xml_accessor :private_note, :from => 'PrivateNote'

      xml_accessor :linked_transactions, :from => 'LinkedTxn', :as => [LinkedTransaction]

      xml_accessor :vendor_ref, :from => 'VendorRef', :as => BaseReference
      xml_accessor :payer_ref, :from => 'PayerRef', :as => BaseReference
      xml_accessor :sales_term_ref, :from => 'SalesTermRef', :as => BaseReference
      xml_accessor :attachable_ref, :from => 'AttachableRef', :as => BaseReference
      xml_accessor :ap_account_ref, :from => 'APAccountRef', :as => BaseReference

      xml_accessor :due_date, :from => 'DueDate', :as => Date
      xml_accessor :remit_to_address, :from => 'RemitToAddr', :as => PhysicalAddress
      xml_accessor :ship_address, :from => 'ShipAddr', :as => PhysicalAddress
      xml_accessor :exchange_rate, :from => 'ExchangeRate', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :balance, :from => 'Balance', :as => BigDecimal, :to_xml => to_xml_big_decimal

      # readonly
      xml_accessor :bill_email, :from => 'BillEmail', :as => EmailAddress
      xml_accessor :reply_email, :from => 'ReplyEmail', :as => EmailAddress
      xml_accessor :total, :from => 'TotalAmt', :as => BigDecimal
      xml_accessor :currency_ref, :from => 'CurrencyRef', :as => BaseReference

      validate :line_item_size

      reference_setters :department_ref, :vendor_ref, :payer_ref, :sales_term_ref, :currency_ref, :attachable_ref, :ap_account_ref
    end
  end
end
