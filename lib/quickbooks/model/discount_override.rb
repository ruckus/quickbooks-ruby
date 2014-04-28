module Quickbooks
  module Model
    class DiscountOverride < BaseModel
      xml_accessor :discount_ref, :from => 'DiscountRef', :as => BaseReference
      xml_accessor :percent_based?, :from => 'PercentBased'
      xml_accessor :discount_percent, :from => 'DiscountPercent', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :discount_account_ref, :from => 'DiscountAccountRef', :as => BaseReference

      reference_setters :discount_ref, :discount_account_ref

    end
  end
end
