# == Business Rules
# * An invoice must have at least one Line that describes an item.
# * An invoice must have CustomerRef populated.
# * The DocNumber attribute is populated automatically by the data service if not supplied.
# * If ShipAddr, BillAddr, or both are not provided, the appropriate customer address from Customer is used to fill those values.
# * DocNumber, if supplied, must be unique.

module Quickbooks
  module Model
    class Invoice < BaseModel
      include DocumentNumbering
      include GlobalTaxCalculation
      include HasLineItems

      #== Constants
      REST_RESOURCE = 'invoice'
      XML_COLLECTION_NODE = "Invoice"
      XML_NODE = "Invoice"
      EMAIL_STATUS_NEED_TO_SEND = 'NeedToSend'
      MINORVERSION = 37

      xml_accessor :id, :from => 'Id'
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :custom_fields, :from => 'CustomField', :as => [CustomField]
      xml_accessor :auto_doc_number, :from => 'AutoDocNumber' # See auto_doc_number! method below for usage
      xml_accessor :doc_number, :from => 'DocNumber'
      xml_accessor :invoice_link, :from => 'InvoiceLink'
      xml_accessor :txn_date, :from => 'TxnDate', :as => Date
      xml_accessor :currency_ref, :from => 'CurrencyRef', :as => BaseReference
      xml_accessor :exchange_rate, :from => 'ExchangeRate', :as => BigDecimal, :to_xml => to_xml_big_decimal
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
      xml_accessor :total, :from => 'TotalAmt', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :home_total, :from => 'HomeTotalAmt', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :apply_tax_after_discount?, :from => 'ApplyTaxAfterDiscount'
      xml_accessor :print_status, :from => 'PrintStatus'
      xml_accessor :email_status, :from => 'EmailStatus'
      xml_accessor :balance, :from => 'Balance', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :home_balance, :from => 'HomeBalance', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :deposit, :from => 'Deposit', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :department_ref, :from => 'DepartmentRef', :as => BaseReference
      xml_accessor :allow_ipn_payment?, :from => 'AllowIPNPayment'
      xml_accessor :delivery_info, :from => 'DeliveryInfo', :as => DeliveryInfo
      xml_accessor :bill_email, :from => 'BillEmail', :as => EmailAddress
      xml_accessor :allow_online_payment?, :from => 'AllowOnlinePayment'
      xml_accessor :allow_online_credit_card_payment?, :from => 'AllowOnlineCreditCardPayment'
      xml_accessor :allow_online_ach_payment?, :from => 'AllowOnlineACHPayment'
      xml_accessor :deposit_to_account_ref, :from => 'DepositToAccountRef', :as => BaseReference


      reference_setters

      #== This adds aliases for backwards compatability to old attributes names
      alias_method :total_amount, :total
      alias_method :total_amount=, :total=
      alias_method :home_total_amount, :home_total
      alias_method :home_total_amount=, :home_total=

      #== Validations
      validate :line_item_size
      validate :existence_of_customer_ref
      validate :required_bill_email_if_email_delivery
      validate :document_numbering

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


      def existence_of_customer_ref
        if customer_ref.nil? || (customer_ref && customer_ref.value == 0)
          errors.add(:customer_ref, "CustomerRef is required and must be a non-zero value.")
        end
      end

    end
  end
end
