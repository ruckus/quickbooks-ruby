module Quickbooks
  module Model
    class Transfer < BaseModel
      XML_COLLECTION_NODE = "Transfer"
      XML_NODE = "Transfer"
      REST_RESOURCE = 'transfer'

      xml_accessor :id, :from => 'Id'
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :txn_date, :from => 'TxnDate', :as => Date
      xml_accessor :currency_ref, :from => 'CurrencyRef', :as => BaseReference
      xml_accessor :private_note, :from => 'PrivateNote'
      xml_accessor :from_account_ref, :from => 'FromAccountRef', :as => BaseReference
      xml_accessor :to_account_ref, :from => 'ToAccountRef', :as => BaseReference
      xml_accessor :amount, :from => 'Amount', :as => BigDecimal, :to_xml => to_xml_big_decimal

      reference_setters :currency_ref, :to_account_ref, :from_account_ref
    end
  end
end