module Quickbooks
  module Model
    class BillPaymentLineItem < BaseModel

      #== Constants
      PAYMENT_LINE_DETAIL = 'PaymentLineDetail'
      DISCOUNT_LINE_DETAIL = 'DiscountLineDetail'

      xml_accessor :id, :from => 'Id'
      xml_accessor :line_num, :from => 'LineNum', :as => Integer
      xml_accessor :description, :from => 'Description'
      xml_accessor :amount, :from => 'Amount', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :detail_type, :from => 'DetailType'

      xml_accessor :linked_transactions, :from => 'LinkedTxn', :as => [LinkedTransaction]

      #== Various detail types

    end
  end
end
