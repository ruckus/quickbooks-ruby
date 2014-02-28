class Quickbooks::Model::BatchResponse < Quickbooks::Model::BaseModel
  class BatchItemResponse
    include ROXML
    xml_name  "BatchItemResponse"

    xml_accessor :bId, :from => "@bId"
    xml_accessor :fault, :from => 'Fault', :as => Quickbooks::Model::Fault
    [:Item, :Account, :Invoice, :Customer, :Bill, :SalesReceipt].each do |model|
      xml_accessor model.to_s.underscore, from: model.to_s, as: "Quickbooks::Model::#{model.to_s}".constantize
    end

    def fault?
      fault
    end
  end

  xml_name  "IntuitResponse"
  xml_accessor :response_items, :from => :BatchItemResponse, as: [Quickbooks::Model::BatchResponse::BatchItemResponse]
end
