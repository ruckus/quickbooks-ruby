module Quickbooks
  module Model
    class BudgetLineItem < BaseModel

      xml_accessor :date, :from => 'BudgetDate', :as => Date
      xml_accessor :amount, :from => 'Amount'
      xml_accessor :account_ref, :from => 'AccountRef', :as => BaseReference
      xml_accessor :customer_ref, :from => 'CustomerRef', :as => BaseReference
      xml_accessor :class_ref, :from => 'ClassRef', :as => BaseReference
      xml_accessor :department_ref, :from => 'DepartmentRef', :as => BaseReference

      reference_setters
    end
  end
end
