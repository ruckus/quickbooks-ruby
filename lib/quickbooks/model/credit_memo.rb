module Quickbooks
  module Model
    class CreditMemo < BaseModel
      XML_COLLECTION_NODE = "CreditMemo"
      XML_NODE = "CreditMemo"
      REST_RESOURCE = 'creditmemo'

      xml_accessor :id, :from => 'Id', :as => Integer
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :doc_number, :from => 'DocNumber'
      xml_accessor :placed_on, :from => 'TxnDate', :as => Time

      xml_accessor :line_items, :from => 'Line', :as => [Model::Line]

      xml_accessor :private_note, :from => 'PrivateNote'

      xml_accessor :customer_ref, :from => 'CustomerRef'
      xml_accessor :customer_memo, :from => 'CustomerMemo'
      xml_accessor :bill_email, :from => 'BillEmail', :as => Model::EmailAddress
      xml_accessor :bill_address, :from => 'BillAddr', :as => Model::PhysicalAddress
      xml_accessor :sales_term_ref, :from => 'SalesTermRef'
      xml_accessor :deposit_to_account_ref, :from => 'DepositToAccountRef'
      xml_accessor :payment_method_ref, :from => 'PaymentMethodRef'

      # readonly
      xml_accessor :total, :from => 'TotalAmt', :as => BigDecimal

      validates_length_of :line_items, :minimum => 1

      def email=(email)
        self.bill_email = Model::EmailAddress.new(email)
      end
    end
  end
end
