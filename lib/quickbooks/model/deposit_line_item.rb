module Quickbooks
  module Model
    class DepositLineItem < BaseModel

      #== Constants
      DEPOSIT_LINE_DETAIL = 'DepositLineDetail'

      xml_accessor :id, :from => 'Id'
      xml_accessor :line_num, :from => 'LineNum', :as => Integer
      xml_accessor :description, :from => 'Description'
      xml_accessor :amount, :from => 'Amount', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :linked_transactions, :from => 'LinkedTxn', :as => [LinkedTransaction]

      xml_accessor :detail_type, :from => 'DetailType'

      #== Various detail types
      xml_accessor :deposit_line_detail, :from => 'DepositLineDetail', :as => DepositLineDetail

      xml_accessor :custom_fields, :from => 'CustomField', :as => [CustomField]


      def deposit_line_detail?
        detail_type.to_s == DEPOSIT_LINE_DETAIL
      end

      def deposit_line_detail!
        self.detail_type = DEPOSIT_LINE_DETAIL
        self.deposit_line_detail = DepositLineDetail.new

        yield self.deposit_line_detail if block_given?
      end

    end
  end
end
