class Quickbooks::Model::BatchRequest < Quickbooks::Model::BaseModel
  class BatchItemRequest
    include ROXML
    XML_NODE = "BatchItemRequest"
    xml_name XML_NODE

    xml_accessor :operation, :from => "@operation"
    xml_accessor :bId, :from => "@bId"
    xml_accessor :customer, from: "Customer", :as => Quickbooks::Model::Customer
    xml_accessor :item, from: "Item", :as => Quickbooks::Model::Item
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
    bir.operation = operation
    bir.bId = batch_item_id
    bir.send("#{batch_item.class::XML_NODE.underscore}=", batch_item)
    self.request_items << bir
  end
end
