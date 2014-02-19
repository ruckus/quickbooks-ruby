# == Business Rules
# * An invoice must have at least one Line that describes an item.
# * An invoice must have CustomerRef populated.
# * The DocNumber attribute is populated automatically by the data service if not supplied.
# * If ShipAddr, BillAddr, or both are not provided, the appropriate customer address from Customer is used to fill those values.
# * DocNumber, if supplied, must be unique.

module Quickbooks
  module Model
    class Invoice < BaseModel

      #== Constants
      REST_RESOURCE = 'invoice'
      XML_COLLECTION_NODE = "Invoice"
      XML_NODE = "Invoice"
      EMAIL_STATUS_NEED_TO_SEND = 'NeedToSend'

      xml_accessor :id, :from => 'Id', :as => Integer
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :custom_fields, :from => 'CustomField', :as => [CustomField]
      xml_accessor :doc_number, :from => 'DocNumber'
      xml_accessor :txn_date, :from => 'TxnDate', :as => Date
      xml_accessor :private_note, :from => 'PrivateNote'
      xml_accessor :linked_transactions, :from => 'LinkedTxn', :as => [LinkedTransaction]
      xml_accessor :line_items, :from => 'Line', :as => [InvoiceLineItem]
      xml_accessor :txn_tax_detail, :from => 'TxnTaxDetail', :as => TransactionTaxDetail
      xml_accessor :customer_ref, :from => 'CustomerRef', :as => BaseReference
      xml_accessor :customer_memo, :from => 'CustomerMemo'
      xml_accessor :billing_address, :from => 'BillAddr', :as => PhysicalAddress
      xml_accessor :shipping_address, :from => 'ShipAddr', :as => PhysicalAddress
      xml_accessor :class_ref, :from => 'ClassRef', :as => BaseReference
      xml_accessor :sales_term_ref, :from => 'SalesTermRef', :as => BaseReference
      xml_accessor :due_date, :from => 'DueDate', :as => Date
      xml_accessor :ship_method_ref, :from => 'ShipMethodRef', :as => BaseReference
      xml_accessor :ship_date, :from => 'ShipDate', :as => Date
      xml_accessor :tracking_num, :from => 'TrackingNum'
      xml_accessor :ar_account_ref, :from => 'ARAccountRef', :as => BaseReference
      xml_accessor :total_amount, :from => 'TotalAmt', :as => BigDecimal, :to_xml => Proc.new { |val| val.to_f }
      xml_accessor :apply_tax_after_discount, :from => 'ApplyTaxAfterDiscount'
      xml_accessor :print_status, :from => 'PrintStatus'
      xml_accessor :email_status, :from => 'EmailStatus'
      xml_accessor :balance, :from => 'Balance', :as => BigDecimal, :to_xml => Proc.new { |val| val.to_f }
      xml_accessor :deposit, :from => 'Deposit', :as => BigDecimal, :to_xml => Proc.new { |val| val.to_f }
      xml_accessor :department_ref, :from => 'DepartmentRef', :as => BaseReference
      xml_accessor :allow_ipn_payment, :from => 'AllowIPNPayment'
      xml_accessor :bill_email, :from => 'BillEmail', :as => EmailAddress
      xml_accessor :allow_online_payment, :from => 'AllowOnlinePayment'
      xml_accessor :allow_online_credit_card_payment, :from => 'AllowOnlineCreditCardPayment'
      xml_accessor :allow_online_ach_payment, :from => 'AllowOnlineACHPayment'

      reference_setters :customer_ref, :class_ref, :sales_term_ref, :ship_method_ref
      reference_setters :ar_account_ref, :department_ref

      #== Validations
      validates_length_of :line_items, :minimum => 1
      validate :existence_of_customer_ref
      validate :required_bill_email_if_email_delivery

      def initialize
        ensure_line_items_initialization
        super
      end

      def required_bill_email_if_email_delivery
        return unless email_status_for_delivery?

        if bill_email.nil?
          errors.add(:bill_email, "BillEmail is required if EmailStatus=NeedToSend")
        end
      end

      def billing_email_address=(email_address_string)
        self.bill_email = EmailAddress.new(email_address_string)
      end

      def wants_billing_email_sent!
        self.email_status = EMAIL_STATUS_NEED_TO_SEND
      end

      def email_status_for_delivery?
        email_status == EMAIL_STATUS_NEED_TO_SEND
      end

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
