module Quickbooks
  module Model
    class DiscountOverride < BaseModel
      xml_accessor :discount_ref, :from => 'DiscountRef', :as => Integer
      xml_accessor :percent_based, :from => 'PercentBased'
      xml_accessor :discount_percent, :from => 'DiscountPercent', :as => BigDecimal, :to_xml => Proc.new { |val| val.to_f }
      xml_accessor :discount_account_ref, :from => 'DiscountAccountRef', :as => Integer

      def percent_based?
        percent_based.to_s == 'true'
      end

    end
  end
end