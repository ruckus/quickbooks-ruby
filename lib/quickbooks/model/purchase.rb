# == General
# This entity represents expenses, such as a purchase made from a vendor.
# There are three types of Purchases: Cash, Check, and Credit Card.
# * Cash Purchase contains information regarding a payment made in cash.
# * Check Purchase contains information regarding a payment made by check.
# * Credit Card Purchase contains information regarding a payment made by credit card.
#
# == Business Rules
# * You must specify an AccountRef for all puchases.
# * TotalAmt attribute must add up to sum of Line.Amount attributes

module Quickbooks
  module Model
    class Purchase < BaseModel
      include GlobalTaxCalculation
      include HasLineItems

      #== Constants
      REST_RESOURCE = 'purchase'
      XML_COLLECTION_NODE = "Purchase"
      XML_NODE = "Purchase"

      xml_accessor :id, :from => 'Id'
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :doc_number, :from => 'DocNumber'
      xml_accessor :txn_date, :from => 'TxnDate', :as => Date
      xml_accessor :private_note, :from => 'PrivateNote'

      xml_accessor :line_items, :from => 'Line', :as => [PurchaseLineItem]
      xml_accessor :account_ref, :from => 'AccountRef', :as => BaseReference
      xml_accessor :txn_tax_detail, :from => 'TxnTaxDetail', :as => TransactionTaxDetail

      xml_accessor :payment_type, :from => 'PaymentType'
      xml_accessor :entity_ref, :from => 'EntityRef', :as => BaseReference
      xml_accessor :remit_to_address, :from => 'RemitToAddr', :as => PhysicalAddress
      xml_accessor :total, :from => 'TotalAmt', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :print_status, :from => 'PrintStatus'
      xml_accessor :department_ref, :from => 'DepartmentRef', :as => BaseReference

      xml_accessor :currency_ref, :from => 'CurrencyRef', :as => BaseReference
      xml_accessor :exchange_rate, :from => 'ExchangeRate', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :linked_transactions, :from => 'LinkedTxn', :as => [LinkedTransaction]
      xml_accessor :credit?, :from => 'Credit'

      reference_setters

      #== Validations
      validate :line_item_size

      #== This adds aliases for backwards compatability to old attributes names
      alias_method :total_amount, :total
      alias_method :total_amount=, :total=

    end
  end
end
