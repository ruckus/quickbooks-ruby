module Quickbooks
  module Model
    class SalesReceipt < BaseModel
      include DocumentNumbering
      XML_COLLECTION_NODE = "SalesReceipt"
      XML_NODE = "SalesReceipt"
      REST_RESOURCE = 'salesreceipt'

      xml_accessor :id, :from => 'Id', :as => Integer
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :auto_doc_number, :from => 'AutoDocNumber' # See auto_doc_number! method below for usage
      xml_accessor :doc_number, :from => 'DocNumber'
      xml_accessor :placed_on, :from => 'TxnDate', :as => Time
      xml_accessor :line_items, :from => 'Line', :as => [Line]
      xml_accessor :customer_ref, :from => 'CustomerRef', :as => BaseReference
      xml_accessor :bill_email, :from => 'BillEmail', :as => EmailAddress
      xml_accessor :bill_address, :from => 'BillAddr', :as => PhysicalAddress
      xml_accessor :ship_address, :from => 'ShipAddr', :as => PhysicalAddress
      xml_accessor :po_number, :from => 'PONumber'
      xml_accessor :ship_method_ref, :from => 'ShipMethodRef'
      xml_accessor :ship_date, :from => 'ShipDate', :as => Time
      xml_accessor :tracking_num, :from => 'TrackingNum'
      xml_accessor :payment_method_ref, :from => 'PaymentMethodRef', :as => BaseReference
      xml_accessor :payment_ref_number, :from => 'PaymentRefNum'
      xml_accessor :deposit_to_account_ref, :from => 'DepositToAccountRef', :as => BaseReference
      xml_accessor :customer_memo, :from => 'CustomerMemo'
      xml_accessor :private_note, :from => 'PrivateNote'

      # readonly
      xml_accessor :total, :from => 'TotalAmt', :as => BigDecimal

      reference_setters :customer_ref, :payment_method_ref, :deposit_to_account_ref

      validate :line_item_size
      validate :document_numbering

      def initialize(*args)
        ensure_line_items_initialization
        super
      end

      def email=(email)
        self.bill_email = EmailAddress.new(email)
      end

    end
  end
end
