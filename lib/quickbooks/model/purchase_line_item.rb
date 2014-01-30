module Quickbooks
  module Model
    class PurchaseLineItem < BaseModel

      #== Constants
      ITEM_BASED_EXPENSE_LINE_DETAIL = 'ItemBasedExpenseLineDetail'
      GROUP_LINE_DETAIL = 'GroupLineDetail'

      xml_accessor :id, :from => 'Id', :as => Integer
      xml_accessor :line_num, :from => 'LineNum', :as => Integer
      xml_accessor :description, :from => 'Description'
      xml_accessor :amount, :from => 'Amount', :as => BigDecimal, :to_xml => Proc.new { |val| val.to_f }
      xml_accessor :detail_type, :from => 'DetailType'

      #== Various detail types
      xml_accessor :item_based_expense_line_detail, :from => ITEM_BASED_EXPENSE_LINE_DETAIL, :as => ItemBasedExpenseLineDetail
      xml_accessor :group_line_detail, :from => GROUP_LINE_DETAIL, :as => GroupLineDetail

    end
  end
end