module Quickbooks
  module Model
    class ItemAdjustmentLineDetail < BaseModel
      xml_accessor :item_ref, :from => 'ItemRef', :as => BaseReference
      xml_accessor :qty_diff, :from => 'QtyDiff', :as => BigDecimal, :to_xml => to_xml_big_decimal

      reference_setters :item_ref
    end
  end
end
