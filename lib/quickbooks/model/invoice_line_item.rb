module Quickbooks
  module Model
    class InvoiceLineItem < BaseModel
      require 'quickbooks/model/invoice_group_line_detail'

      #== Constants
      SALES_LINE_ITEM_DETAIL = 'SalesItemLineDetail'
      SUB_TOTAL_LINE_DETAIL = 'SubTotalLineDetail'
      PAYMENT_LINE_DETAIL = 'PaymentLineDetail'
      DISCOUNT_LINE_DETAIL = 'DiscountLineDetail'
      INVOICE_GROUP_LINE_DETAIL = 'GroupLineDetail'
      DESCRIPTION_LINE_DETAIL = 'DescriptionLineDetail'
      DESCRIPTION_DETAIL_TYPE = 'DescriptionOnly'

      xml_accessor :id, :from => 'Id'
      xml_accessor :line_num, :from => 'LineNum', :as => Integer
      xml_accessor :description, :from => 'Description'
      xml_accessor :amount, :from => 'Amount', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :detail_type, :from => 'DetailType'

      #== Various detail types
      xml_accessor :sales_line_item_detail, :from => SALES_LINE_ITEM_DETAIL, :as => SalesItemLineDetail
      xml_accessor :sub_total_line_detail, :from => SUB_TOTAL_LINE_DETAIL, :as => SubTotalLineDetail
      xml_accessor :payment_line_detail, :from => PAYMENT_LINE_DETAIL, :as => PaymentLineDetail
      xml_accessor :discount_line_detail, :from => DISCOUNT_LINE_DETAIL, :as => DiscountLineDetail
      xml_accessor :group_line_detail, :from => INVOICE_GROUP_LINE_DETAIL, :as => InvoiceGroupLineDetail
      xml_accessor :description_line_detail, :from => DESCRIPTION_LINE_DETAIL, :as => DescriptionLineDetail

      def group_line_detail?
        detail_type.to_s == INVOICE_GROUP_LINE_DETAIL
      end

      def sales_item?
        detail_type.to_s == SALES_LINE_ITEM_DETAIL
      end

      def sub_total_item?
        detail_type.to_s == SUB_TOTAL_LINE_DETAIL
      end

      def discount_item?
        detail_type.to_s == DISCOUNT_LINE_DETAIL
      end

      def description_only?
        # The detail type for a description-only line detail differs slightly
        # from the node name (DescriptionOnly vs DescriptionLineDetail)
        detail_type.to_s == DESCRIPTION_DETAIL_TYPE
      end

      def sales_item!
        self.detail_type = SALES_LINE_ITEM_DETAIL
        self.sales_line_item_detail = SalesItemLineDetail.new

        yield self.sales_line_item_detail if block_given?
      end

      def group_line_detail!
        self.detail_type = INVOICE_GROUP_LINE_DETAIL
        self.group_line_detail = InvoiceGroupLineDetail.new

        yield self.group_line_detail if block_given?
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

      def description_only!
        self.detail_type = DESCRIPTION_DETAIL_TYPE
        self.description_line_detail = DescriptionLineDetail.new

        yield self.description_line_detail if block_given?
      end

    end
  end
end
