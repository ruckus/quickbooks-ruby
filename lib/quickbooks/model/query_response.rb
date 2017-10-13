module Quickbooks
  module Model
    class QueryResponse < BaseModel
      XML_COLLECTION_NODE = "Query"
      XML_NODE = "Query"
      REST_RESOURCE = 'query'

      xml_name XML_NODE

      # Supported Entities
      xml_accessor :accounts, from: "Account", as: [Quickbooks::Model::Account]
      xml_accessor :bill_payments, from: "BillPayment", as: [Quickbooks::Model::BillPayment]
      xml_accessor :bills, from: "Bill", as: [Quickbooks::Model::Bill]
      xml_accessor :credit_memos, from: "CreditMemo", as: [Quickbooks::Model::CreditMemo]
      xml_accessor :customers, from: "Customer", as: [Quickbooks::Model::Customer]
      xml_accessor :invoices, from: "Invoice", as: [Quickbooks::Model::Invoice]
      xml_accessor :items, from: "Item", as: [Quickbooks::Model::Item]
      xml_accessor :journal_entries, from: "JournalEntry", as: [Quickbooks::Model::JournalEntry]
      xml_accessor :payments, from: "Payment", as: [Quickbooks::Model::Payment]
      xml_accessor :purchase_orders, from: "PurchaseOrder", as: [Quickbooks::Model::PurchaseOrder]
      xml_accessor :purchases, from: "Purchase", as: [Quickbooks::Model::Purchase]
      xml_accessor :refund_receipts, from: "RefundReceipt", as: [Quickbooks::Model::RefundReceipt]
      xml_accessor :sales_receipts, from: "SalesReceipt", as: [Quickbooks::Model::SalesReceipt]
      xml_accessor :time_activities, from: "TimeActivity", as: [Quickbooks::Model::TimeActivity]
      xml_accessor :vendors, from: "Vendor", as: [Quickbooks::Model::Vendor]

    end
  end
end
