module Quickbooks
  module Model
    class PaymentLineDetail < BaseModel
      xml_accessor :item_ref, :from => 'ItemRef', :as => BaseReference
      xml_accessor :class_ref, :from => 'ClassRef', :as => BaseReference
      xml_accessor :balance, :from => 'Balance', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :discount, :from => 'Discount', :as => DiscountOverride

      reference_setters :item_ref, :class_ref
    end
  end
end
