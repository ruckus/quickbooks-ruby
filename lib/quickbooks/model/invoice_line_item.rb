module Quickbooks
  module Model
    class InvoiceLineItem < BaseModel

      #== Constants
      SALES_LINE_ITEM_DETAIL = 'SalesItemLineDetail'
      SUB_TOTAL_LINE_DETAIL = 'SubTotalLineDetail'
      PAYMENT_LINE_DETAIL = 'PaymentLineDetail'
      DISCOUNT_LINE_DETAIL = 'DiscountLineDetail'

      xml_accessor :id, :from => 'Id'
      xml_accessor :line_num, :from => 'LineNum', :as => Integer
      xml_accessor :description, :from => 'Description'
      xml_accessor :amount, :from => 'Amount', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :detail_type, :from => 'DetailType'

      #== Various detail types
      xml_accessor :sales_line_item_detail, :from => 'SalesItemLineDetail', :as => SalesItemLineDetail
      xml_accessor :sub_total_line_detail, :from => 'SubTotalLineDetail', :as => SubTotalLineDetail
      xml_accessor :payment_line_detail, :from => 'PaymentLineDetail', :as => PaymentLineDetail
      xml_accessor :discount_line_detail, :from => 'DiscountLineDetail', :as => DiscountLineDetail

      def sales_item?
        detail_type.to_s == SALES_LINE_ITEM_DETAIL
      end

      def sub_total_item?
        detail_type.to_s == SUB_TOTAL_LINE_DETAIL
      end

      def discount_item?
        detail_type.to_s == DISCOUNT_LINE_DETAIL
      end

      def sales_item!
        self.detail_type = SALES_LINE_ITEM_DETAIL
        self.sales_line_item_detail = SalesItemLineDetail.new

        yield self.sales_line_item_detail if block_given?
      end

      def payment_item!
        self.detail_type = PAYMENT_LINE_DETAIL
        self.payment_line_detail = PaymentLineDetail.new

        yield self.payment_line_detail if block_given?
      end

      def discount_item!
        self.detail_type = DISCOUNT_LINE_DETAIL
        self.discount_line_detail = DiscountLineDetail.new

        yield self.discount_line_detail if block_given?
      end

    end
  end
end
