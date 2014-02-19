module Quickbooks
  module Model
    class PaymentMethod < BaseModel
      REST_RESOURCE = 'paymentmethod'
      XML_COLLECTION_NODE = "PaymentMethod"
      XML_NODE = "PaymentMethod"

      xml_accessor :id, :from => 'Id', :as => Integer
      xml_accessor :name, :from => 'Name'
      xml_accessor :active?, :from => 'Active'
      xml_accessor :amount, :from => 'Amount', :as => BigDecimal, :to_xml => Proc.new { |val| val.to_f }
    end
  end
end
