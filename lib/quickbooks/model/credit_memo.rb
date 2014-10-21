module Quickbooks
  module Model
    class CreditMemo < BaseModel
      include DocumentNumbering
      include GlobalTaxCalculation

      XML_COLLECTION_NODE = "CreditMemo"
      XML_NODE = "CreditMemo"
      REST_RESOURCE = 'creditmemo'

      xml_accessor :id, :from => 'Id', :as => Integer
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :auto_doc_number, :from => 'AutoDocNumber' # See auto_doc_number! method below for usage
      xml_accessor :doc_number, :from => 'DocNumber'
      xml_accessor :txn_date, :from => 'TxnDate', :as => Date
      xml_accessor :department_ref, :from => 'DepartmentRef', :as => BaseReference

      xml_accessor :line_items, :from => 'Line', :as => [Line]
      xml_accessor :txn_tax_detail, :from => 'TxnTaxDetail', :as => TransactionTaxDetail
      xml_accessor :private_note, :from => 'PrivateNote'

      xml_accessor :customer_ref, :from => 'CustomerRef', :as => BaseReference
      xml_accessor :customer_memo, :from => 'CustomerMemo'
      xml_accessor :bill_email, :from => 'BillEmail', :as => EmailAddress
      xml_accessor :bill_address, :from => 'BillAddr', :as => PhysicalAddress
      xml_accessor :sales_term_ref, :from => 'SalesTermRef', :as => BaseReference
      xml_accessor :deposit_to_account_ref, :from => 'DepositToAccountRef', :as => BaseReference
      xml_accessor :payment_method_ref, :from => 'PaymentMethodRef', :as => BaseReference

      # readonly
      xml_accessor :total, :from => 'TotalAmt', :as => BigDecimal

      # backward-compatible alias
      alias_attribute :placed_on, :txn_date

      validate :line_item_size
      validate :document_numbering

      reference_setters :department_ref, :customer_ref, :sales_term_ref, :deposit_to_account_ref, :payment_method_ref

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
