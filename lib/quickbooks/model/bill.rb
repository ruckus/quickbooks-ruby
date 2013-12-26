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

      xml_accessor :line_items, :from => 'Line', :as => [Model::Line]

      xml_accessor :private_note, :from => 'PrivateNote'

      xml_accessor :vendor_ref, :from => 'VendorRef', :as => Model::BaseReference
      xml_accessor :payer_ref, :from => 'PayerRef', :as => Model::BaseReference
      xml_accessor :sales_term_ref, :from => 'SalesTermRef', :as => Model::BaseReference

      xml_accessor :due_date, :from => 'DueDate', :as => Date
      xml_accessor :remit_to_address, :from => 'RemitToAddr', :as => Model::PhysicalAddress
      xml_accessor :ship_address, :from => 'ShipAddr', :as => Model::PhysicalAddress

      # readonly
      xml_accessor :bill_email, :from => 'BillEmail', :as => Model::EmailAddress
      xml_accessor :reply_email, :from => 'ReplyEmail', :as => Model::EmailAddress
      xml_accessor :total, :from => 'TotalAmt', :as => BigDecimal

      validates_length_of :line_items, :minimum => 1

      # def email=(email)
      #   self.bill_email = Model::EmailAddress.new(email)
      # end
    end
  end
end
