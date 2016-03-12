module Quickbooks
  module Model
    class DeliveryInfo < BaseModel
      xml_accessor :delivery_type, :from => 'DeliveryType'
      xml_accessor :delivery_time, :from => 'DeliveryTime', :as => DateTime
    end
  end
end
