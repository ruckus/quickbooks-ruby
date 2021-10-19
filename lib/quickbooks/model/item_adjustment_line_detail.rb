# frozen_string_literal: true

module Quickbooks
  module Model
    class ItemAdjustmentLineDetail < BaseModel
      xml_accessor :qty_diff, from: 'QtyDiff'
      xml_accessor :item_ref, from: 'ItemRef', as: BaseReference
      xml_accessor :class_ref, from: 'ClassRef', as: BaseReference
      xml_accessor :sales_price, from: 'SalesPrice', as: BigDecimal, to_xml: proc { |val| val.nil? ? nil : val.to_f }

      reference_setters :item_ref, :class_ref
    end
  end
end
