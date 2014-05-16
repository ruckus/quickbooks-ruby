module Quickbooks
  module Model
    class Line < BaseModel
      #== Constants
      SALES_LINE_ITEM_DETAIL = 'SalesItemLineDetail'
      SUB_TOTAL_LINE_DETAIL = 'SubTotalLineDetail'
      PAYMENT_LINE_DETAIL = 'PaymentLineDetail'
      DISCOUNT_LINE_DETAIL = 'DiscountLineDetail'
      JOURNAL_ENTRY_LINE_DETAIL = 'JournalEntryLineDetail'

      xml_accessor :id, :from => 'Id', :as => Integer
      xml_accessor :line_num, :from => 'LineNum', :as => Integer
      xml_accessor :description, :from => 'Description'
      xml_accessor :amount, :from => 'Amount', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :detail_type, :from => 'DetailType'
      xml_accessor :linked_transactions, :from => 'LinkedTxn', :as => [LinkedTransaction]

      #== Various detail types
      xml_accessor :sales_item_line_detail, :from => 'SalesItemLineDetail', :as => SalesItemLineDetail
      xml_accessor :sub_total_line_detail, :from => 'SubTotalLineDetail', :as => SubTotalLineDetail
      xml_accessor :payment_line_detail, :from => 'PaymentLineDetail', :as => PaymentLineDetail
      xml_accessor :discount_line_detail, :from => 'DiscountLineDetail', :as => DiscountOverride
      xml_accessor :journal_entry_line_detail, :from => 'JournalEntryLineDetail', :as => JournalEntryLineDetail
      xml_accessor :linked_transaction, :from => 'LinkedTxn', :as => LinkedTransaction

      def invoice_id=(invoice_id)
        self.linked_transaction = LinkedTransaction.new(txn_id: invoice_id,
                                                        txn_type: "Invoice")
      end

      def sales_item!
        self.detail_type = SALES_LINE_ITEM_DETAIL
        self.sales_item_line_detail = SalesItemLineDetail.new

        yield self.sales_item_line_detail if block_given?
      end
    end
  end
end
