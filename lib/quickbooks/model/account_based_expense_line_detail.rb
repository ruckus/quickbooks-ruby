module Quickbooks
  module Model
    class AccountBasedExpenseLineDetail < BaseModel
      xml_accessor :customer_ref, :from => 'CustomerRef', :as => Model::BaseReference
      xml_accessor :class_ref, :from => 'ClassRef', :as => Model::BaseReference
      xml_accessor :account_ref, :from => 'AccountRef', :as => Model::BaseReference
      xml_accessor :billable_status, :from => 'BillableStatus'
      xml_accessor :tax_amount, :from => 'UnitPrice', :as => BigDecimal, :to_xml => Proc.new { |val| val.to_f }
      xml_accessor :tax_code_ref, :from => 'TaxCodeRef'
    end
  end
end