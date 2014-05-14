# https://developer.intuit.com/docs/0025_quickbooksapi/0050_data_services/030_entity_services_reference/invoice#DiscountLineDetail
module Quickbooks
  module Model
    class DiscountLineDetail < BaseModel
      xml_accessor :discount_ref, :from => 'DiscountRef', :as => BaseReference
      xml_accessor :percent_based?, :from => 'PercentBased'
      xml_accessor :discount_percent, :from => 'DiscountPercent', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :discount_account_ref, :from => 'DiscountAccountRef', :as => BaseReference
      xml_accessor :class_ref, :from => 'ClassRef', :as => BaseReference
      xml_accessor :tax_code_ref, :from => 'TaxCodeRef', :as => BaseReference

      reference_setters :tax_code_ref, :class_ref, :discount_ref, :discount_account_ref
    end
  end
end
