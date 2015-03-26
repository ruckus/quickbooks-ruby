module Quickbooks
  module Model
    class BudgetLineItem < BaseModel

      xml_accessor :date, :from => 'BudgetDate', :as => Date
      xml_accessor :amount, :from => 'Amount'
      xml_accessor :account_ref, :from => 'AccountRef', :as => BaseReference

      reference_setters
    end
  end
end
