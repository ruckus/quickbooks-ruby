# === Business Rules
# * The VendorRef attribute must be specified.
# * At lease one Line with Line.Amount must be specified.

module Quickbooks
  module Model
    class VendorCredit < BaseModel
      include GlobalTaxCalculation
      include HasLineItems

      #== Constants
      REST_RESOURCE = 'vendorcredit'
      XML_COLLECTION_NODE = "VendorCredit"
      XML_NODE = "VendorCredit"

      xml_accessor :id, :from => 'Id'
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :doc_number, :from => 'DocNumber'
      xml_accessor :txn_date, :from => 'TxnDate', :as => Date
      xml_accessor :private_note, :from => 'PrivateNote'

      xml_accessor :line_items, :from => 'Line', :as => [PurchaseLineItem]
      xml_accessor :department_ref, :from => 'DepartmentRef', :as => BaseReference
      xml_accessor :ap_account_ref, :from => 'APAccountRef', :as => BaseReference
      xml_accessor :vendor_ref, :from => 'VendorRef', :as => BaseReference
      xml_accessor :total, :from => 'TotalAmt', :as => BigDecimal, :to_xml => Proc.new { |val| val.to_f }

      xml_accessor :currency_ref, :from => 'CurrencyRef', :as => BaseReference
      xml_accessor :exchange_rate, :from => 'ExchangeRate', :as => BigDecimal, :to_xml => to_xml_big_decimal

      reference_setters

      #== This adds aliases for backwards compatability to old attributes names
      alias_method :total_amount, :total
      alias_method :total_amount=, :total=

    end
  end
end
