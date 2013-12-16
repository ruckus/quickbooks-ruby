# Business Rules
# * The item name must be unique.
# * Service item types  must have IncomeAccountRef.
# * Service item types must have ExpenseAccountRef.

module Quickbooks
  module Model
    class Item < BaseModel

      XML_COLLECTION_NODE = "Item"
      XML_NODE = "Item"
      REST_RESOURCE = 'item'

      INVENTORY_TYPE = 'Inventory'
      NON_INVENTORY_TYPE = 'Non Inventory'
      SERVICE_TYPE = 'Service'
      ITEM_TYPES = [INVENTORY_TYPE, NON_INVENTORY_TYPE, SERVICE_TYPE]

      xml_name 'Item'
      xml_accessor :id, :from => 'Id', :as => Integer
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => Quickbooks::Model::MetaData
      xml_accessor :attachable_ref, :from => 'AttachableRef', :as => Integer
      xml_accessor :name, :from => 'Name'
      xml_accessor :description, :from => 'Description'
      xml_accessor :active, :from => 'Active'
      xml_accessor :parent_ref, :from => 'ParentRef', :as => Integer
      xml_accessor :sub_item, :from => 'SubItem'
      xml_accessor :unit_price, :from => 'UnitPrice', :as => BigDecimal, :to_xml => Proc.new { |val| val.to_f }
      xml_accessor :rate_percent, :from => 'RatePercent', :as => BigDecimal, :to_xml => Proc.new { |val| val.to_f }
      xml_accessor :type, :from => 'Type'
      xml_accessor :taxable, :from => 'Taxable'
      xml_accessor :asset_account_ref, :from => 'AssetAccountRef', :as => Integer
      xml_accessor :income_account_ref, :from => 'IncomeAccountRef', :as => Integer
      xml_accessor :purchase_desc, :from => 'PurchaseDesc'
      xml_accessor :purchase_cost, :from => 'PurchaseCost', :as => BigDecimal, :to_xml => Proc.new { |val| val.to_f }
      xml_accessor :expense_account_ref, :from => 'ExpenseAccountRef', :as => Integer
      xml_accessor :quantity_on_hand, :from => 'QtyOnHand', :as => BigDecimal, :to_xml => Proc.new { |val| val.to_f }
      xml_accessor :sales_tax_code_ref, :from => 'SalesTaxCodeRef', :as => Integer
      xml_accessor :purchase_tax_code_ref, :from => 'PurchaseTaxCodeRef', :as => Integer
      xml_accessor :track_quantity_on_hand, :from => 'TrackQtyOnHand'
      xml_accessor :asset_account, :from => 'AssetAccount', :as => Integer
      xml_accessor :level, :from => 'Level', :as => Integer
      xml_accessor :sales_tax_included, :from => 'SalesTaxIncluded'
      xml_accessor :purchase_tax_included, :from => 'PurchaseTaxIncluded'

      validates_length_of :name, :minimum => 1
      validates_inclusion_of :type, :in => ITEM_TYPES

      def initialize
        self.type = INVENTORY_TYPE
        super
      end

      def active?
        active.to_s == 'true'
      end

      def sub_item?
        sub_item.to_s == 'true'
      end

      def taxable?
        taxable.to_s == 'true'
      end

      def track_quantity_on_hand?
        track_quantity_on_hand.to_s == 'true'
      end

      def sales_tax_included?
        sales_tax_included.to_s == 'true'
      end

      def purchase_tax_included?
        purchase_tax_included.to_s == 'true'
      end

      def valid_for_create?
        valid?
        errors.empty?
      end

      # To delete an object Intuit requires we provide Id and SyncToken fields
      def valid_for_deletion?
        return false if(id.nil? || sync_token.nil?)
        id.to_i > 0 && !sync_token.to_s.empty? && sync_token.to_i >= 0
      end

      def valid_for_update?
        if sync_token.nil?
          errors.add(:sync_token, "Missing required attribute SyncToken for update")
        end
        errors.empty?
      end

    end
  end
end