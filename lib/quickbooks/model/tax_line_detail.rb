module Quickbooks
  module Model
    class TaxLineDetail < BaseModel

      xml_accessor :percent_based?, :from => 'PercentBased'
      xml_accessor :net_amount_taxable, :from => 'NetAmountTaxable', :as => BigDecimal, :to_xml => Proc.new { |val| val.to_f }
      xml_accessor :tax_inclusive_amount, :from => 'TaxInclusiveAmount', :as => BigDecimal, :to_xml => Proc.new { |val| val.to_f }
      xml_accessor :override_delta_amount, :from => 'OverrideDeltaAmount', :as => BigDecimal, :to_xml => Proc.new { |val| val.to_f }
      xml_accessor :tax_percent, :from => 'TaxPercent', :as => BigDecimal, :to_xml => Proc.new { |val| val.to_f }
      xml_accessor :tax_rate_ref, :from => 'TaxRateRef', :as => BaseReference

      reference_setters :tax_rate_ref
      
    end
  end
end
