module Quickbooks
  module Model
    class Bill < BaseModel
      XML_COLLECTION_NODE = "Bill"
      XML_NODE = "Bill"
      REST_RESOURCE = 'bill'

      xml_accessor :id, :from => 'Id', :as => Integer
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :doc_number, :from => 'DocNumber'
      xml_accessor :txn_date, :from => 'TxnDate', :as => Date
      xml_accessor :department_ref, :from => 'DepartmentRef', :as => BaseReference

      xml_accessor :line_items, :from => 'Line', :as => [BillLineItem]

      xml_accessor :private_note, :from => 'PrivateNote'

      xml_accessor :vendor_ref, :from => 'VendorRef', :as => BaseReference
      xml_accessor :payer_ref, :from => 'PayerRef', :as => BaseReference
      xml_accessor :sales_term_ref, :from => 'SalesTermRef', :as => BaseReference

      xml_accessor :due_date, :from => 'DueDate', :as => Date
      xml_accessor :remit_to_address, :from => 'RemitToAddr', :as => PhysicalAddress
      xml_accessor :ship_address, :from => 'ShipAddr', :as => PhysicalAddress

      # readonly
      xml_accessor :bill_email, :from => 'BillEmail', :as => EmailAddress
      xml_accessor :reply_email, :from => 'ReplyEmail', :as => EmailAddress
      xml_accessor :total, :from => 'TotalAmt', :as => BigDecimal

      validate :line_item_size

      reference_setters :department_ref, :vendor_ref, :payer_ref, :sales_term_ref
    end
  end
end
