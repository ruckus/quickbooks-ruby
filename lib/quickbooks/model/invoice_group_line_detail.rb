module Quickbooks
  module Model
    class InvoiceGroupLineDetail < InvoiceLineItem
      include HasLineItems

      xml_accessor :id, :from => 'Id'
      xml_accessor :group_item_ref, :from => 'GroupItemRef', :as => BaseReference
      xml_accessor :quantity, :from => 'Quantity', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :line_items, :from => 'Line', :as => [InvoiceLineItem]

      reference_setters :group_item_ref
    end
  end
end
