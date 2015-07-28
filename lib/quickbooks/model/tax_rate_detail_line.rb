module Quickbooks
  module Model
    class TaxRateDetailLine < BaseModel
      XML_COLLECTION_NODE = "TaxRateDetails"
      XML_NODE = "TaxRateDetails"

      xml_accessor :tax_rate_id, :from => "TaxRateId"
      xml_accessor :tax_rate_name, :from => "TaxRateName"
      xml_accessor :rate_value, :from => "RateValue"
      xml_accessor :tax_agency_id, :from => "TaxAgencyId"
      xml_accessor :tax_applicable_on, :from => 'TaxApplicableOn', :as => :text

      validates_presence_of :tax_agency_id, if: Proc.new {|line| line.tax_rate_id.blank?}
      validates_presence_of :tax_rate_name, if: Proc.new {|line| line.tax_rate_id.blank?}
      validates_presence_of :rate_value,    if: Proc.new {|line| line.tax_rate_id.blank?}
      validates_presence_of :tax_rate_id,   if: Proc.new {|line| line.tax_rate_name.blank? && tax_agency_id.blank? && rate_value.blank? }

    end
  end
end
