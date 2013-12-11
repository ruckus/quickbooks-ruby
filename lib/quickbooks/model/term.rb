module Quickbooks
  module Model
    
    class Term < BaseModel
      
      #== Constants
      REST_RESOURCE = 'term'
      XML_COLLECTION_NODE = "Term"
      XML_NODE = "Term"
      EMAIL_STATUS_NEED_TO_SEND = 'NeedToSend'
      
      xml_accessor :id, :from => 'Id', :as => Integer
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => Quickbooks::Model::MetaData
      xml_accessor :custom_fields, :from => 'CustomField', :as => [Quickbooks::Model::CustomField]
      xml_accessor :name, :from => 'Name'
      xml_accessor :customer_ref, :from => 'CustomerRef', :as => Quickbooks::Model::CustomerRef
      
      #to get customer id
      def customer_id=(customer_id)
        self.customer_ref = Quickbooks::Model::CustomerRef.new(customer_id)
      end
      
      
      private

      def existence_of_customer_ref
        if customer_ref.nil? || (customer_ref && customer_ref.value == 0)
          errors.add(:customer_ref, "CustomerRef is required and must be a non-zero value.")
        end
      end
      
    end
  end
end