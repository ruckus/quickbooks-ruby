module Quickbooks
  module Model
    class Line < BaseModel
      #== Constants
      SALES_LINE_ITEM_DETAIL = 'SalesItemLineDetail'
      SUB_TOTAL_LINE_DETAIL = 'SubTotalLineDetail'
      PAYMENT_LINE_DETAIL = 'PaymentLineDetail'

      xml_accessor :id, :from => 'Id', :as => Integer
      xml_accessor :line_num, :from => 'LineNum', :as => Integer
      xml_accessor :description, :from => 'Description'
      xml_accessor :amount, :from => 'Amount', :as => Float
      xml_accessor :detail_type, :from => 'DetailType'

      #== Various detail types
      xml_accessor :sales_item_line_detail, :from => 'SalesItemLineDetail', :as => Quickbooks::Model::SalesItemLineDetail
      xml_accessor :sub_total_line_detail, :from => 'SubTotalLineDetail', :as => Quickbooks::Model::SubTotalLineDetail
      xml_accessor :payment_line_detail, :from => 'PaymentLineDetail', :as => Quickbooks::Model::PaymentLineDetail

      def sales_item!
        self.detail_type = SALES_LINE_ITEM_DETAIL
        self.sales_item_line_detail = Quickbooks::Model::SalesItemLineDetail.new

        yield self.sales_item_line_detail if block_given?
      end
    end
  end
end
