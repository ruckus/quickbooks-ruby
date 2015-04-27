module GlobalTaxCalculation
  extend ActiveSupport::Concern

  TAX_INCLUSIVE = "TaxInclusive"
  TAX_EXCLUDED = "TaxExcluded"
  NOT_APPLICABLE = "NotApplicable"
  GLOBAL_TAX_CALCULATION = [TAX_INCLUSIVE, TAX_EXCLUDED, NOT_APPLICABLE]

  included do
    xml_accessor :global_tax_calculation, :from => 'GlobalTaxCalculation'
    validates_inclusion_of :global_tax_calculation, :in => GLOBAL_TAX_CALCULATION, allow_blank: true
  end
end
