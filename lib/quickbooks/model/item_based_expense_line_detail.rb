require 'quickbooks/model/markup_info'

module Quickbooks
  module Model
    class ItemBasedExpenseLineDetail < BaseModel
      xml_accessor :item_ref, :from => 'ItemRef', :as => BaseReference
      xml_accessor :class_ref, :from => 'ClassRef', :as => BaseReference
      xml_accessor :unit_price, :from => 'UnitPrice', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :rate_percent, :from => 'RatePercent', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :price_level_ref, :from => 'PriceLevelRef', :as => BaseReference
      xml_accessor :markup_info, :from => 'MarkupInfo', :as => MarkupInfo
      xml_accessor :quantity, :from => 'Qty', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :tax_code_ref, :from => 'TaxCodeRef', :as => BaseReference
      xml_accessor :customer_ref, :from => 'CustomerRef', :as => BaseReference
      xml_accessor :billable_status, :from => 'BillableStatus'

      reference_setters :item_ref, :class_ref, :price_level_ref, :customer_ref, :tax_code_ref
    end
  end
end
