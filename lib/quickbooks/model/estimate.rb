# == Business Rules
# The Estimate object has the following business rules and validations:
# * An Estimate must have at least one line that describes an item.
# * An Estimate must have a reference to a customer.
# * If shipping address and billing address are not provided, the customer address is used to fill those values.
# * For US country, CustomSalesTax cannot be used as TaxCodeRef.

module Quickbooks
  module Model
    class Estimate < BaseModel
      include GlobalTaxCalculation
      include HasLineItems

      #== Constants
      REST_RESOURCE = 'estimate'
      XML_COLLECTION_NODE = "Estimate"
      XML_NODE = "Estimate"

      xml_accessor :id, :from => 'Id'
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :custom_fields, :from => 'CustomField', :as => [CustomField]
      xml_accessor :doc_number, :from => 'DocNumber'
      xml_accessor :txn_date, :from => 'TxnDate', :as => Date
      xml_accessor :private_note, :from => 'PrivateNote'

      xml_accessor :department_ref, :from => 'DepartmentRef', :as => BaseReference
      xml_accessor :linked_transactions, :from => 'LinkedTxn', :as => [LinkedTransaction]
      xml_accessor :line_items, :from => 'Line', :as => [InvoiceLineItem]
      xml_accessor :txn_tax_detail, :from => 'TxnTaxDetail', :as => TransactionTaxDetail
      xml_accessor :txn_status, :from => 'TxnStatus'

      xml_accessor :customer_ref, :from => 'CustomerRef', :as => BaseReference
      xml_accessor :customer_memo, :from => 'CustomerMemo'
      xml_accessor :billing_address, :from => 'BillAddr', :as => PhysicalAddress
      xml_accessor :shipping_address, :from => 'ShipAddr', :as => PhysicalAddress
      xml_accessor :class_ref, :from => 'ClassRef', :as => BaseReference
      xml_accessor :sales_term_ref, :from => 'SalesTermRef', :as => BaseReference
      xml_accessor :total, :from => 'TotalAmt', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :ship_method_ref, :from => 'ShipMethodRef', :as => BaseReference
      xml_accessor :ship_date, :from => 'ShipDate', :as => Date

      xml_accessor :currency_ref, :from => 'CurrencyRef', :as => BaseReference
      xml_accessor :exchange_rate, :from => 'ExchangeRate', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :due_date, :from => 'DueDate', :as => Date
      xml_accessor :deposit_to_account_ref, :from => 'DepositToAccountRef', :as => BaseReference

      xml_accessor :apply_tax_after_discount?, :from => 'ApplyTaxAfterDiscount'
      xml_accessor :print_status, :from => 'PrintStatus'
      xml_accessor :email_status, :from => 'EmailStatus'
      xml_accessor :bill_email, :from => 'BillEmail', :as => EmailAddress
      xml_accessor :expiration_date, :from => 'ExpirationDate', :as => Date
      xml_accessor :accepted_by, :from => 'AcceptedBy'
      xml_accessor :accepted_date, :from => 'AcceptedDate', :as => Date

      reference_setters

      #== This adds aliases for backwards compatability to old attributes names
      alias_method :total_amount, :total
      alias_method :total_amount=, :total=

      #== Validations
      validate :line_item_size
      validate :existence_of_customer_ref

      private

      def existence_of_customer_ref
        if customer_ref.nil? || (customer_ref && customer_ref.value == 0)
          errors.add(:customer_ref, "CustomerRef is required and must be a non-zero value.")
        end
      end

    end
  end
end
