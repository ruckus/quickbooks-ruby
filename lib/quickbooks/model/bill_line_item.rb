module Quickbooks
  module Model
    class BillLineItem < BaseModel

      #== Constants
      ACCOUNT_BASED_EXPENSE_LINE_DETAIL = 'AccountBasedExpenseLineDetail'
      ITEM_BASED_EXPENSE_LINE_DETAIL = 'ItemBasedExpenseLineDetail'

      xml_accessor :id, :from => 'Id', :as => Integer
      xml_accessor :line_num, :from => 'LineNum', :as => Integer
      xml_accessor :description, :from => 'Description'
      xml_accessor :amount, :from => 'Amount', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :detail_type, :from => 'DetailType'

      #== Various detail types
      xml_accessor :account_based_expense_line_detail, :from => 'AccountBasedExpenseLineDetail', :as => AccountBasedExpenseLineDetail
      xml_accessor :item_based_expense_line_detail, :from => 'ItemBasedExpenseLineDetail', :as => ItemBasedExpenseLineDetail

      def account_based_expense_item?
        detail_type.to_s == ACCOUNT_BASED_EXPENSE_LINE_DETAIL
      end

      def item_based_expense_item?
        detail_type.to_s == ITEM_BASED_EXPENSE_LINE_DETAIL
      end

    end
  end
end
