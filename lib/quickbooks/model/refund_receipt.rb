module Quickbooks
  module Model
    class RefundReceipt < BaseModel
      include GlobalTaxCalculation
      include HasLineItems

      XML_COLLECTION_NODE = "RefundReceipt"
      XML_NODE = "RefundReceipt"
      REST_RESOURCE = 'refundreceipt'

      xml_accessor :id, :from => 'Id'
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :auto_doc_number, :from => 'AutoDocNumber' # See auto_doc_number! method below for usage
      xml_accessor :doc_number, :from => 'DocNumber'
      xml_accessor :line_items, :from => 'Line', :as => [Line]
      xml_accessor :customer_ref, :from => 'CustomerRef', :as => BaseReference
      xml_accessor :department_ref, :from => 'DepartmentRef', :as => BaseReference
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
      xml_accessor :txn_tax_detail, :from => 'TxnTaxDetail', :as => TransactionTaxDetail
      xml_accessor :txn_date, :from => 'TxnDate', :as => Date
      xml_accessor :custom_fields, :from => 'CustomField', :as => [CustomField]
      xml_accessor :currency_ref, :from => 'CurrencyRef', :as => BaseReference
      xml_accessor :class_ref, :from => 'ClassRef', :as => BaseReference
      xml_accessor :apply_tax_after_discount?, :from => 'ApplyTaxAfterDiscount'
      xml_accessor :print_status, :from => 'PrintStatus'
      xml_accessor :balance, :from => 'Balance', :as => BigDecimal, :to_xml => to_xml_big_decimal

      xml_accessor :exchange_rate, :from => 'ExchangeRate', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :linked_transactions, :from => 'LinkedTxn', :as => [LinkedTransaction]

      # readonly
      xml_accessor :total, :from => 'TotalAmt', :as => BigDecimal
      xml_accessor :home_total, :from => 'HomeTotalAmt', :as => BigDecimal, :to_xml => to_xml_big_decimal

      # backward-compatible alias
      alias_attribute :placed_on, :txn_date

      include DocumentNumbering
      reference_setters

      validate :line_item_size
      validate :document_numbering

      def email=(email)
        self.bill_email = EmailAddress.new(email)
      end

    end
  end
end
