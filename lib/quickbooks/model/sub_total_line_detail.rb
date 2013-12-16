module Quickbooks
  module Model
    class SubTotalLineDetail < BaseModel
      xml_accessor :item_ref, :from => 'ItemRef', :as => Integer
      xml_accessor :class_ref, :from => 'ClassRef'
      xml_accessor :unit_price, :from => 'UnitPrice', :as => BigDecimal, :to_xml => Proc.new { |val| val.to_f }
      xml_accessor :quantity, :from => 'Qty', :as => BigDecimal, :to_xml => Proc.new { |val| val.to_f }
      xml_accessor :tax_code_ref, :from => 'TaxCodeRef'
    end
  end
end