class Quickbooks::Model::BatchResponse < Quickbooks::Model::BaseModel
  class BatchItemResponse
    include ROXML
    xml_name  "BatchItemResponse"

    xml_accessor :bId, :from => "@bId"
    xml_accessor :fault, :from => 'Fault', :as => Quickbooks::Model::Fault

    # Supported Entities
    xml_accessor :account, from: "Account", as: Quickbooks::Model::Account
    xml_accessor :bill_payment, from: "BillPayment", as: Quickbooks::Model::BillPayment
    xml_accessor :bill, from: "Bill", as: Quickbooks::Model::Bill
    xml_accessor :credit_memo, from: "CreditMemo", as: Quickbooks::Model::CreditMemo
    xml_accessor :customer, from: "Customer", as: Quickbooks::Model::Customer
    xml_accessor :invoice, from: "Invoice", as: Quickbooks::Model::Invoice
    xml_accessor :item, from: "Item", as: Quickbooks::Model::Item
    xml_accessor :journal_entry, from: "JournalEntry", as: Quickbooks::Model::JournalEntry
    xml_accessor :payment, from: "Payment", as: Quickbooks::Model::Payment
    xml_accessor :purchase_order, from: "PurchaseOrder", as: Quickbooks::Model::PurchaseOrder
    xml_accessor :purchase, from: "Purchase", as: Quickbooks::Model::Purchase
    xml_accessor :refund_receipt, from: "RefundReceipt", as: Quickbooks::Model::RefundReceipt
    xml_accessor :sales_receipt, from: "SalesReceipt", as: Quickbooks::Model::SalesReceipt
    xml_accessor :time_activity, from: "TimeActivity", as: Quickbooks::Model::TimeActivity
    xml_accessor :vendor, from: "Vendor", as: Quickbooks::Model::Vendor

    def fault?
      fault
    end
  end

  xml_name  "IntuitResponse"
  xml_accessor :response_items, :from => :BatchItemResponse, as: [Quickbooks::Model::BatchResponse::BatchItemResponse]
end
