module Quickbooks
  module Model
    class SalesItemLineDetail < BaseModel
      xml_accessor :item_ref, :from => 'ItemRef', :as => Integer
      xml_accessor :class_ref, :from => 'ClassRef', :as => Integer
      xml_accessor :unit_price, :from => 'UnitPrice', :as => Float
      xml_accessor :rate_percent, :from => 'RatePercent', :as => Float
      xml_accessor :price_level_ref, :from => 'PriceLevelRef', :as => Integer
      xml_accessor :quantity, :from => 'Qty', :as => Float
      xml_accessor :tax_code_ref, :from => 'TaxCodeRef'
      xml_accessor :service_date, :from => 'ServiceDate', :as => Date
    end
  end
end