module Quickbooks
  module Model
    class BillPaymentLineItem < BaseModel

      #== Constants
      PAYMENT_LINE_DETAIL = 'PaymentLineDetail'
      DISCOUNT_LINE_DETAIL = 'DiscountLineDetail'

      xml_accessor :id, :from => 'Id', :as => Integer
      xml_accessor :line_num, :from => 'LineNum', :as => Integer
      xml_accessor :description, :from => 'Description'
      xml_accessor :amount, :from => 'Amount', :as => BigDecimal, :to_xml => Proc.new { |val| val.to_f }
      xml_accessor :detail_type, :from => 'DetailType'

      xml_accessor :linked_transactions, :from => 'LinkedTxn', :as => [Quickbooks::Model::LinkedTransaction]

      #== Various detail types

    end
  end
end