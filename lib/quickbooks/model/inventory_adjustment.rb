module Quickbooks
  module Model
    class InventoryAdjustment < BaseModel
      include HasLineItems

      XML_COLLECTION_NODE = "InventoryAdjustment"
      XML_NODE = "InventoryAdjustment"
      REST_RESOURCE = 'inventoryadjustment'

      # Requires minorversion >= 70

      xml_accessor :id, :from => 'Id'
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :doc_number, :from => 'DocNumber'
      xml_accessor :txn_date, :from => 'TxnDate', :as => Date
      xml_accessor :private_note, :from => 'PrivateNote'
      xml_accessor :adjust_account_ref, :from => 'AdjustAccountRef', :as => BaseReference
      xml_accessor :line_items, :from => 'Line', :as => [InventoryAdjustmentLineItem]

      validates_presence_of :adjust_account_ref

      reference_setters :adjust_account_ref

      def build_line_item_for(item_id: , qty_diff:)
        line_item = Quickbooks::Model::InventoryAdjustmentLineItem.new().tap do |line_item|
          line_item.detail_type = InventoryAdjustmentLineItem::ITEM_ADJUSTMENT_LINE_DETAIL

          adjustment_line_detail = ItemAdjustmentLineDetail.new
          adjustment_line_detail.item_id = item_id
          adjustment_line_detail.qty_diff = qty_diff

          line_item.item_adjustment_line_detail = adjustment_line_detail
        end
        line_items << line_item

        self
      end
    end
  end
end
