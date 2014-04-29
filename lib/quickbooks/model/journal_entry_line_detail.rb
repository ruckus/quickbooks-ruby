module Quickbooks
  module Model
    class JournalEntryLineDetail < BaseModel
      include NameEntity::Quality

      xml_accessor :posting_type, :from => 'PostingType'
      # xml_accessor :entity_type # TODO - Implement
      # xml_accessor :entity_ref # TODO - Implement
      xml_accessor :account_ref, :from => 'AccountRef', :as => BaseReference
      xml_accessor :class_ref, :from => 'ClassRef', :as => BaseReference
      xml_accessor :department_ref, :from => 'DepartmentRef', :as => BaseReference

      # TODO - Implement
      # xml_accessor :tax_code_ref, :from => 'TaxCodeRef', :as => BaseReference
      # xml_accessor :tax_applicable_on, :from => 'TaxApplicableOn' # This is not documented anywhere!
      # xml_accessor :tax_amount, :from => 'TaxAmount', :as => BigDecimal, :to_xml => to_xml_big_decimal

      xml_accessor :billable_status, :from => 'BillableStatus'

      reference_setters :account_ref, :class_ref, :department_ref#, :tax_code_ref, :entity_ref

      validates_length_of :description, :maximum => 4000
      validate :posting_type_is_valid
      validate :billable_status_is_valid
    end
  end
end
