module Quickbooks
  module Model
    
    class Payment < BaseModel
      
       #== Constants
      REST_RESOURCE = 'payment'
      XML_COLLECTION_NODE = "Payment"
      XML_NODE = "Payment"
      EMAIL_STATUS_NEED_TO_SEND = 'NeedToSend'
      
      xml_accessor :id, :from => 'Id', :as => Integer
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => Quickbooks::Model::MetaData
      xml_accessor :custom_fields, :from => 'CustomField', :as => [Quickbooks::Model::CustomField]
      xml_accessor :doc_number, :from => 'DocNumber'
      xml_accessor :txn_date, :from => 'TxnDate', :as => Date
      xml_accessor :private_note, :from => 'PrivateNote'
      xml_accessor :linked_transactions, :from => 'LinkedTxn', :as => [Quickbooks::Model::LinkedTransaction]
      xml_accessor :line_items, :from => 'Line', :as => [Quickbooks::Model::InvoiceLineItem]
      xml_accessor :txn_tax_detail, :from => 'TxnTaxDetail'
      xml_accessor :customer_ref, :from => 'CustomerRef', :as => Quickbooks::Model::CustomerRef
      xml_accessor :ar_account_ref, :from => 'ARAccountRef', :as => Integer
      xml_accessor :total_amount, :from => 'TotalAmt', :as => Float
      
      #== Validations
      validates_length_of :line_items, :minimum => 1
      validate :existence_of_customer_ref
      
      def initialize
        ensure_line_items_initialization
        super
      end
      
      def customer_id=(customer_id)
        self.customer_ref = Quickbooks::Model::CustomerRef.new(customer_id)
      end

      private

      def existence_of_customer_ref
        if customer_ref.nil? || (customer_ref && customer_ref.value == 0)
          errors.add(:customer_ref, "CustomerRef is required and must be a non-zero value.")
        end
      end

      def ensure_line_items_initialization
        self.line_items ||= []
      end
      
    end
  end
end