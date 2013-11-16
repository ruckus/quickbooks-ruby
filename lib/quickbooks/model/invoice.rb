# == Business Rules
# * An invoice must have at least one Line that describes an item.
# * An invoice must have CustomerRef populated.
# * The DocNumber attribute is populated automatically by the data service if not supplied.
# * If ShipAddr, BillAddr, or both are not provided, the appropriate customer address from Customer is used to fill those values.
# * DocNumber, if supplied, must be unique.

module Quickbooks
  module Model
    class Invoice < BaseModel

      REST_RESOURCE = 'invoice'
      XML_COLLECTION_NODE = "Invoice"
      XML_NODE = "Invoice"

      xml_accessor :id, :from => 'Id'
      xml_accessor :sync_token, :from => 'SyncToken'
      xml_accessor :meta_data, :from => 'MetaData', :as => Quickbooks::Model::MetaData
      xml_accessor :custom_fields, :from => 'CustomField', :as => [Quickbooks::Model::CustomField]
      xml_accessor :doc_number, :from => 'DocNumber'
      xml_accessor :txn_date, :from => 'TxnDate'
      xml_accessor :private_note, :from => 'PrivateNote'
      xml_accessor :linked_transactions, :from => 'LinkedTxn', :as => [Quickbooks::Model::LinkedTransaction]
      xml_accessor :line_items, :from => 'Line', :as => [Quickbooks::Model::InvoiceLineItem]
      xml_accessor :txn_tax_detail, :from => 'TxnTaxDetail'
      xml_accessor :customer_ref, :from => 'CustomerRef', :as => Quickbooks::Model::CustomerRef
      xml_accessor :customer_memo, :from => 'CustomerMemo'
      xml_accessor :billing_address, :from => 'BillAddr', :as => Quickbooks::Model::PhysicalAddress
      xml_accessor :shipping_address, :from => 'ShipAddr', :as => Quickbooks::Model::PhysicalAddress
      xml_accessor :class_ref, :from => 'ClassRef'
      xml_accessor :sales_term_ref, :from => 'SalesTermRef'
      xml_accessor :due_date, :from => 'DueDate', :as => Date
      xml_accessor :ship_method_ref, :from => 'ShipMethodRef'
      xml_accessor :ship_date, :from => 'ShipDate', :as => Date
      xml_accessor :tracking_num, :from => 'TrackingNum'
      xml_accessor :ar_account_ref, :from => 'ARAccountRef'
      xml_accessor :total_amount, :from => 'TotalAmt', :as => Float
      xml_accessor :apply_tax_after_discount, :from => 'ApplyTaxAfterDiscount'
      xml_accessor :print_status, :from => 'PrintStatus'
      xml_accessor :email_status, :from => 'EmailStatus'
      xml_accessor :balance, :from => 'Balance', :as => Float
      xml_accessor :deposit, :from => 'Deposit', :as => Float
      xml_accessor :department_ref, :from => 'DepartmentRef'
      xml_accessor :allow_ipn_payment, :from => 'AllowIPNPayment'
      xml_accessor :allow_online_payment, :from => 'AllowOnlinePayment'
      xml_accessor :allow_online_credit_card_payment, :from => 'AllowOnlineCreditCardPayment'
      xml_accessor :allow_online_ach_payment, :from => 'AllowOnlineACHPayment'

      def apply_tax_after_discount?
        apply_tax_after_discount.to_s == 'true'
      end

      def allow_ipn_payment?
        allow_ipn_payment.to_s == 'true'
      end

      def allow_online_payment?
        allow_online_payment.to_s == 'true'
      end

      def allow_online_credit_card_payment?
        allow_online_credit_card_payment.to_s == 'true'
      end

      def allow_online_ach_payment?
        allow_online_ach_payment.to_s == 'true'
      end

    end
  end
end
