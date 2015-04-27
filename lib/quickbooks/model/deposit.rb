# == Business Rules
# * There must be at least one line item included in a create request
# * Any transaction that funds the Undeposited Funds account can be linked to a Deposit object with Deposit.Line.LinkedTxn

module Quickbooks
  module Model
    class Deposit < BaseModel
      include DocumentNumbering
      include HasLineItems

      #== Constants
      XML_COLLECTION_MODE = "Deposit"
      XML_NODE = "Deposit"
      REST_RESOURCE = "deposit"

      xml_accessor :id, :from => "Id", :as => Integer
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :custom_fields, :from => 'CustomField', :as => [CustomField]
      xml_accessor :auto_doc_number, :from => 'AutoDocNumber' # See auto_doc_number! method below for usage
      xml_accessor :doc_number, :from => 'DocNumber'
      xml_accessor :txn_date, :from => 'TxnDate', :as => Date
      xml_accessor :department_ref, :from => 'DepartmentRef', :as => BaseReference
      xml_accessor :currency_ref, :from => 'CurrencyRef', :as => BaseReference
      xml_accessor :exchange_rate, :from => 'ExchangeRate', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :private_note, :from => 'PrivateNote'
      xml_accessor :txn_status, :from => 'TxnStatus'
      xml_accessor :line_items, :from => 'Line', :as => [DepositLineItem]
      xml_accessor :txn_tax_detail, :from => 'TxnTaxDetail', :as => TransactionTaxDetail
      xml_accessor :deposit_to_account_ref, :from => 'DepositToAccountRef', :as => BaseReference
      xml_accessor :total, :from => 'TotalAmt', :as => BigDecimal, :to_xml => to_xml_big_decimal


      reference_setters :department_ref, :currency_ref, :deposit_to_account_ref

      #== Validations
      validate :line_item_size
      validate :document_numbering

      private

    end
  end
end