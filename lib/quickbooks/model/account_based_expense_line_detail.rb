module Quickbooks
  module Model
    class AccountBasedExpenseLineDetail < BaseModel
      xml_accessor :customer_ref, :from => 'CustomerRef', :as => BaseReference
      xml_accessor :class_ref, :from => 'ClassRef', :as => BaseReference
      xml_accessor :account_ref, :from => 'AccountRef', :as => BaseReference
      xml_accessor :billable_status, :from => 'BillableStatus'
      xml_accessor :tax_amount, :from => 'UnitPrice', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :tax_code_ref, :from => 'TaxCodeRef', :as => BaseReference
      xml_accessor :tax_inclusive_amount, from: 'TaxInclusiveAmt', :as => BigDecimal, to_xml: Proc.new { |val| val.to_f }

      reference_setters :customer_ref, :class_ref, :account_ref, :tax_code_ref

    end
  end
end
