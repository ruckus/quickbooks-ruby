module Quickbooks
  module Model
    class PurchaseOrder < BaseModel
      include GlobalTaxCalculation
      include HasLineItems

      #== Constants
      REST_RESOURCE = 'purchaseorder'
      XML_COLLECTION_NODE = "PurchaseOrder"
      XML_NODE = "PurchaseOrder"
      MINORVERSION = 45

      xml_accessor :id, :from => 'Id'
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :doc_number, :from => 'DocNumber'
      xml_accessor :txn_date, :from => 'TxnDate', :as => Date
      xml_accessor :custom_fields, :from => 'CustomField', :as => [CustomField]
      xml_accessor :private_note, :from => 'PrivateNote'
      xml_accessor :memo, :from => 'Memo'

      xml_accessor :linked_transactions, :from => 'LinkedTxn', :as => [LinkedTransaction]
      xml_accessor :line_items, :from => 'Line', :as => [PurchaseLineItem]

      xml_accessor :attachable_ref, :from => 'AttachableRef', :as => BaseReference
      xml_accessor :vendor_ref, :from => 'VendorRef', :as => BaseReference
      xml_accessor :ap_account_ref, :from => 'APAccountRef', :as => BaseReference
      xml_accessor :class_ref, :from => 'ClassRef', :as => BaseReference
      xml_accessor :sales_term_ref, :from => 'SalesTermRef', :as => BaseReference

      xml_accessor :total, :from => 'TotalAmt', :as => BigDecimal, :to_xml => Proc.new { |val| val.to_f }
      xml_accessor :due_date, :from => 'DueDate', :as => Date
      xml_accessor :vendor_address, :from => 'VendorAddr', :as => PhysicalAddress
      xml_accessor :ship_address, :from => 'ShipAddr', :as => PhysicalAddress
      xml_accessor :ship_method_ref, :from => 'ShipMethodRef', :as => BaseReference
      xml_accessor :po_status, :from => 'POStatus'
      xml_accessor :txn_tax_detail, :from => 'TxnTaxDetail', :as => TransactionTaxDetail

      xml_accessor :currency_ref, :from => 'CurrencyRef', :as => BaseReference
      xml_accessor :exchange_rate, :from => 'ExchangeRate', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :tax_code_ref, :from => 'TaxCodeRef', :as => BaseReference

      reference_setters

      #== This adds aliases for backwards compatability to old attributes names
      alias_method :total_amount, :total
      alias_method :total_amount=, :total=

    end
  end
end
