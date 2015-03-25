module Quickbooks
  module Model
    class JournalEntry < BaseModel
      include HasLineItems

      XML_COLLECTION_NODE = "JournalEntry"
      XML_NODE = "JournalEntry"
      REST_RESOURCE = 'journalentry'

      xml_accessor :id, :from => 'Id'
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :doc_number, :from => 'DocNumber'
      xml_accessor :txn_date, :from => 'TxnDate', :as => Date
      xml_accessor :exchange_rate, :from => 'ExchangeRate', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :private_note, :from => 'PrivateNote'
      xml_accessor :line_items, :from => 'Line', :as => [Line]
      xml_accessor :txn_tax_detail, :from => 'TxnTaxDetail', :as => TransactionTaxDetail

      # Readonly
      xml_accessor :currency_ref, :from => 'CurrencyRef', :as => BaseReference
      xml_accessor :total, :from => 'TotalAmt', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :home_total, :from => 'HomeTotalAmt', :as => BigDecimal, :to_xml => to_xml_big_decimal

      #== This adds aliases for backwards compatability to old attributes names
      alias_method :total_amount, :total
      alias_method :total_amount=, :total=

      xml_accessor :adjustment?, :from => 'Adjustment'

      reference_setters :currency_ref

      validates_length_of :private_note, :maximum => 4000
    end
  end
end
