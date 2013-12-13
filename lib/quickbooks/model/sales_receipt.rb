module Quickbooks
  module Model
    class SalesReceipt < BaseModel
      XML_COLLECTION_NODE = "SalesReceipt"
      XML_NODE = "SalesReceipt"
      REST_RESOURCE = 'salesreceipt'

      xml_accessor :id, :from => 'Id', :as => Integer
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :doc_number, :from => 'DocNumber'
      xml_accessor :placed_on, :from => 'TxnDate', :as => Time

      xml_accessor :line_items, :from => 'Line', :as => [Model::Line]
      xml_accessor :customer_ref, :from => 'CustomerRef'
      xml_accessor :bill_email, :from => 'BillEmail', :as => Model::EmailAddress
      xml_accessor :bill_address, :from => 'BillAddr', :as => Model::PhysicalAddress
      xml_accessor :ship_address, :from => 'ShipAddr', :as => Model::PhysicalAddress

      xml_accessor :po_number, :from => 'PONumber'

      xml_accessor :shipping_method, :from => 'ShipMethodRef', :as => Model::ShipMethodRef
      xml_accessor :ship_date, :from => 'ShipDate', :as => Time

      xml_accessor :payment_method_ref, :from => 'PaymentMethodRef'
      xml_accessor :payment_ref_number, :from => 'PaymentRefNum'

      xml_accessor :deposit_to_account_ref, :from => 'DepositToAccountRef'

      # readonly
      xml_accessor :total, :from => 'TotalAmt', :as => BigDecimal

      validates_length_of :line_items, :minimum => 1
    end
  end
end
