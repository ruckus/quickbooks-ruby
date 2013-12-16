module Quickbooks
  module Model
    class PaymentLineDetail < BaseModel
      xml_accessor :item_ref, :from => 'ItemRef', :as => Integer
      xml_accessor :class_ref, :from => 'ClassRef', :as => Integer
      xml_accessor :balance, :from => 'Balance', :as => BigDecimal, :to_xml => Proc.new { |val| val.to_f }
      xml_accessor :discount, :from => 'Discount', :as => Quickbooks::Model::DiscountOverride
    end
  end
end