class Quickbooks::Model::BatchRequest < Quickbooks::Model::BaseModel
  class BatchItemRequest
    include ROXML
    XML_NODE = "BatchItemRequest"
    xml_name XML_NODE

    xml_accessor :operation, :from => "@operation"
    xml_accessor :bId, :from => "@bId"

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
    xml_accessor :query, from: "Query"
  end

  XML_COLLECTION_NODE = "IntuitBatchRequest"
  XML_NODE = "IntuitBatchRequest"
  REST_RESOURCE = 'batch'
  xml_name XML_NODE
  xml_accessor :request_items, from: "BatchItemRequest", as: [Quickbooks::Model::BatchRequest::BatchItemRequest]

  def initialize
    self.request_items = []
  end

  def add(batch_item_id, batch_item, operation)
    bir = Quickbooks::Model::BatchRequest::BatchItemRequest.new
    bir.bId = batch_item_id
    if operation == "query"
      bir.query = batch_item
    else
      bir.operation = operation
      bir.send("#{batch_item.class::XML_NODE.underscore}=", batch_item)
    end
    self.request_items << bir
  end
end
