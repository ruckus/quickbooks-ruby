module Quickbooks
  module Model
    class TaxRateDetailLine < BaseModel

      xml_accessor :tax_rate_id, :from => "TaxRateId"
      xml_accessor :tax_rate_name, :from => "TaxRateName"
      xml_accessor :rate_value, :from => "RateValue"
      xml_accessor :tax_agency_id, :from => "TaxAgencyId"
      xml_accessor :tax_applicable_on, :from => 'TaxApplicableOn', :as => :text

      validates :tax_rate_name, presence: true, length: { maximum: 100 }, if: Proc.new {|line| line.tax_rate_id.blank?}
      validates :tax_agency_id, presence: true, numericality: {greater_than: 0}, if: Proc.new {|line| line.tax_rate_id.blank?}
      validates :rate_value, presence: true, numericality: {less_than_or_equal_to: 100},  if: Proc.new {|line| line.tax_rate_id.blank?}
      validates :tax_rate_id, numericality: true, if: Proc.new {|line| line.tax_rate_name.blank? && tax_agency_id.blank? && rate_value.blank? }

      validates :tax_applicable_on, inclusion: {in: %w(Sales Purchase)}

      def to_json
        attributes.inject({}){|mem, item| mem[item.first.camelize] = item.last if item.last.present?; mem}
      end
    end
  end
end
