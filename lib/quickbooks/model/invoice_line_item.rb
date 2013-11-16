module Quickbooks
  module Model
    class InvoiceLineItem < BaseModel
      xml_accessor :id, :from => 'Id'
      xml_accessor :line_num, :from => 'LineNum'
      xml_accessor :description, :from => 'Description'
      xml_accessor :amount, :from => 'Amount', :as => Float
      xml_accessor :detail_type, :from => 'DetailType'

      #== Various detail types
      xml_accessor :sales_line_item_detail, :from => 'SalesItemLineDetail', :as => Quickbooks::Model::SalesItemLineDetail
      xml_accessor :subtotal_line_detail, :from => 'SubtotalLineDetail', :as => Quickbooks::Model::SubtotalLineDetail
    end
  end
end