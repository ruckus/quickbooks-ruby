module Quickbooks
  module Model
    class SalesReceipt < BaseModel
      XML_COLLECTION_NODE = "SalesReceipt"
      XML_NODE = "SalesReceipt"
      REST_RESOURCE = 'salesreceipt'

      xml_name 'Item'
      xml_accessor :id, :from => 'Id', :as => Integer
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :doc_number, :from => 'DocNumber', :as => Integer
      xml_accessor :line_items, :from => 'Line', :as => [Model::Item]

      xml_accessor :customer_ref, :from => 'CustomerRef', :as => Model::CustomerRef

      xml_accessor :email, :from => 'BillEmail'
      xml_accessor :bill_address, :from => 'BillAddr', :as => Model::PhysicalAddress
      xml_accessor :ship_address, :from => 'ShipAddr', :as => Model::PhysicalAddress

      xml_accessor :po_number, :from => 'PONumber'

      xml_accessor :shipping_method, :from => 'ShipMethodRef', :as => Model::ShipMethodRef
      xml_accessor :ship_date, :from => 'ShipDate', :as => Time

      xml_accessor :payment_method, :from => 'PaymentMethodRef', :as => Model::PaymentMethodRef
      xml_accessor :payment_ref_number, :from => 'PaymentRefNum'

      # readonly
      xml_accessor :total, :from => 'TotalAmt', :as => BigDecimal
    end
  end
end
