# frozen_string_literal: true

module Quickbooks
  module Model
    class ItemAdjustmentLineItem < BaseModel
      require 'quickbooks/model/item_adjustment_line_detail'

      ITEM_ADJUSTMENT_LINE_DETAIL = 'ItemAdjustmentLineDetail'

      xml_accessor :detail_type, from: 'DetailType'
      #== Various detail types
      xml_accessor :item_adjustment_line_detail, from: ITEM_ADJUSTMENT_LINE_DETAIL, as: ItemAdjustmentLineDetail

      def item_based?
        detail_type.to_s == ITEM_ADJUSTMENT_LINE_DETAIL
      end
    end
  end
end
