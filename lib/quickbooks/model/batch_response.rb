class Quickbooks::Model::BatchResponse < Quickbooks::Model::BaseModel
  class BatchItemResponse
    include ROXML
    xml_name  "BatchItemResponse"

    xml_accessor :bId, :from => "@bId"
    xml_accessor :customer, :from => 'Customer', :as => Quickbooks::Model::Customer
    xml_accessor :item, :from => 'Item', :as => Quickbooks::Model::Item
    xml_accessor :fault, :from => 'Fault', :as => Quickbooks::Model::Fault

    def fault?
      fault
    end
  end

  xml_name  "IntuitResponse"
  xml_accessor :response_items, :from => :BatchItemResponse, as: [Quickbooks::Model::BatchResponse::BatchItemResponse]
end
