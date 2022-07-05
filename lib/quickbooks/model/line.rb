module Quickbooks
  module Model
    class Line < BaseModel
      require 'quickbooks/model/group_line_detail'

      #== Constants
      SALES_ITEM_LINE_DETAIL = 'SalesItemLineDetail'
      SUB_TOTAL_LINE_DETAIL = 'SubTotalLineDetail'
      PAYMENT_LINE_DETAIL = 'PaymentLineDetail'
      DISCOUNT_LINE_DETAIL = 'DiscountLineDetail'
      JOURNAL_ENTRY_LINE_DETAIL = 'JournalEntryLineDetail'
      GROUP_LINE_DETAIL = 'GroupLineDetail'

      xml_accessor :id, :from => 'Id'
      xml_accessor :line_num, :from => 'LineNum', :as => Integer
      xml_accessor :description, :from => 'Description'
      xml_accessor :amount, :from => 'Amount', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :detail_type, :from => 'DetailType'
      xml_accessor :linked_transactions, :from => 'LinkedTxn', :as => [LinkedTransaction]
      xml_accessor :line_extras, :from => 'LineEx', :as => LineEx

      #== Various detail types
      xml_accessor :sales_item_line_detail, :from => 'SalesItemLineDetail', :as => SalesItemLineDetail
      xml_accessor :sub_total_line_detail, :from => 'SubTotalLineDetail', :as => SubTotalLineDetail
      xml_accessor :payment_line_detail, :from => 'PaymentLineDetail', :as => PaymentLineDetail
      xml_accessor :discount_line_detail, :from => 'DiscountLineDetail', :as => DiscountOverride
      xml_accessor :journal_entry_line_detail, :from => 'JournalEntryLineDetail', :as => JournalEntryLineDetail
      xml_accessor :group_line_detail, :from => 'GroupLineDetail', :as => GroupLineDetail

      def initialize(*args)
        self.linked_transactions ||= []
        super
      end

      def invoice_id=(id)
        update_linked_transactions([id], 'Invoice')
      end
      alias_method :invoice_ids=, :invoice_id=

      def credit_memo_id=(id)
        update_linked_transactions([id], 'CreditMemo')
      end
      alias_method :credit_memo_ids=, :credit_memo_id=

      def sales_item!
        self.detail_type = SALES_ITEM_LINE_DETAIL
        self.sales_item_line_detail = SalesItemLineDetail.new

        yield self.sales_item_line_detail if block_given?
      end

      def sub_total!
        self.detail_type = SUB_TOTAL_LINE_DETAIL
        self.sub_total_line_detail = SubTotalLineDetail.new

        yield self.sub_total_line_detail if block_given?
      end

      def payment!
        self.detail_type = PAYMENT_LINE_DETAIL
        self.payment_line_detail = PaymentLineDetail.new

        yield self.payment_line_detail if block_given?
      end

      def discount!
        self.detail_type = DISCOUNT_LINE_DETAIL
        self.discount_line_detail = DiscountLineDetail.new

        yield self.discount_line_detail if block_given?
      end

      def journal_entry!
        self.detail_type = JOURNAL_ENTRY_LINE_DETAIL
        self.journal_entry_line_detail = JournalEntryLineDetail.new

        yield self.journal_entry_line_detail if block_given?
      end

      def group_line!
        self.detail_type = GROUP_LINE_DETAIL
        self.group_line_detail = GroupLineDetail.new

        yield self.group_line_detail if block_given?
      end

      private

      def update_linked_transactions(txn_ids, txn_type)
        remove_linked_transactions(txn_type)
        txn_ids.flatten.compact.each do |id|
          add_linked_transaction(id, txn_type)
        end
      end

      def remove_linked_transactions(txn_type)
        self.linked_transactions.delete_if { |lt| lt.txn_type == txn_type }
      end

      def add_linked_transaction(txn_id, txn_type)
        self.linked_transactions << LinkedTransaction.new(txn_id: txn_id,
                                                          txn_type: txn_type)
      end
    end
  end
end
