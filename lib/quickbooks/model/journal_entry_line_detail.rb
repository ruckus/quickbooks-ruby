module Quickbooks
  module Model
    class JournalEntryLineDetail < BaseModel
      include NameEntity::Quality

      xml_accessor :posting_type, :from => 'PostingType'
      xml_accessor :entity, :from => 'Entity', :as => Entity
      xml_accessor :account_ref, :from => 'AccountRef', :as => BaseReference
      xml_accessor :class_ref, :from => 'ClassRef', :as => BaseReference
      xml_accessor :department_ref, :from => 'DepartmentRef', :as => BaseReference

      xml_accessor :tax_code_ref, :from => 'TaxCodeRef', :as => BaseReference
      xml_accessor :tax_applicable_on, :from => 'TaxApplicableOn', :as => :text
      xml_accessor :tax_amount, :from => 'TaxAmount', :as => BigDecimal, :to_xml => to_xml_big_decimal

      xml_accessor :billable_status, :from => 'BillableStatus'

      reference_setters :account_ref, :class_ref, :department_ref, :tax_code_ref

      validates_length_of :description, :maximum => 4000
      validates_numericality_of :tax_amount, allow_nil: true, greater_than_or_equal_to:0.0, less_than_or_equal_to:999999999.0
      validate :posting_type_is_valid
      validate :billable_status_is_valid
      validate :journal_line_entry_tax
    end
  end
end
