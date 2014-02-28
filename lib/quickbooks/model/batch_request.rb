class Quickbooks::Model::BatchRequest < Quickbooks::Model::BaseModel
  class BatchItemRequest
    include ROXML
    XML_NODE = "BatchItemRequest"
    xml_name XML_NODE

    xml_accessor :operation, :from => "@operation"
    xml_accessor :bId, :from => "@bId"
    [:Item, :Account, :Invoice, :Customer, :Bill, :SalesReceipt].each do |model|
      xml_accessor model.to_s.underscore, from: model.to_s, as: "Quickbooks::Model::#{model.to_s}".constantize
    end
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
