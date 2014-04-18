module Quickbooks
  module Model
    class SalesItemLineDetail < BaseModel
      xml_accessor :item_ref, :from => 'ItemRef', :as => BaseReference
      xml_accessor :class_ref, :from => 'ClassRef', :as => BaseReference
      xml_accessor :unit_price, :from => 'UnitPrice', :as => BigDecimal, :to_xml => Proc.new { |val| val.to_f }
      xml_accessor :rate_percent, :from => 'RatePercent', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :price_level_ref, :from => 'PriceLevelRef', :as => BaseReference
      xml_accessor :quantity, :from => 'Qty', :as => BigDecimal, :to_xml => Proc.new { |val| val.to_f }
      xml_accessor :tax_code_ref, :from => 'TaxCodeRef', :as => BaseReference
      xml_accessor :service_date, :from => 'ServiceDate', :as => Date

      reference_setters :item_ref, :class_ref, :price_level_ref, :tax_code_ref
    end
  end
end
