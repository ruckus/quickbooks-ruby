module Quickbooks
  module Model
    class InventoryAdjustmentLineItem < BaseModel
      require 'quickbooks/model/item_adjustment_line_detail'

      ITEM_ADJUSTMENT_LINE_DETAIL = 'ItemAdjustmentLineDetail'

      xml_accessor :detail_type, :from => 'DetailType'
      xml_accessor :item_adjustment_line_detail, :from => ITEM_ADJUSTMENT_LINE_DETAIL, :as => ItemAdjustmentLineDetail

      
    end
  end
end