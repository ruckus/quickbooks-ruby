# frozen_string_literal: true

module Quickbooks
  module Model
    class InventoryAdjustment < BaseModel
      require 'quickbooks/model/item_adjustment_line_item'
      include HasLineItems

      REST_RESOURCE = 'inventoryadjustment'
      XML_COLLECTION_NODE = 'InventoryAdjustment'
      XML_NODE = 'InventoryAdjustment'

      xml_accessor :adjust_account_ref, from: 'AdjustAccountRef', as: BaseReference
      xml_accessor :id, from: 'Id'
      xml_accessor :sync_token, from: 'SyncToken', as: Integer
      xml_accessor :meta_data, from: 'MetaData', as: MetaData
      xml_accessor :doc_number, from: 'DocNumber'
      xml_accessor :txn_date, from: 'TxnDate', as: Date

      xml_accessor :department_ref, from: 'DepartmentRef', as: BaseReference
      xml_accessor :private_note, from: 'PrivateNote'
      xml_accessor :customer_ref, from: 'CustomerRef', as: BaseReference

      xml_accessor :line_items, from: 'Line', as: [Line]
      xml_accessor :shipping_adjustment, from: 'ShippingAdjustment'

      reference_setters :adjust_account_ref

      #== Validations
      validate :line_item_size
    end
  end
end
