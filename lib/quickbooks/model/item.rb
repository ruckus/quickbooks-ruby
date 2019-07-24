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
      MINORVERSION = 33

      INVENTORY_TYPE = 'Inventory'
      NON_INVENTORY_TYPE = 'NonInventory'
      SERVICE_TYPE = 'Service'
      CATEGORY_TYPE = 'Category'
      ITEM_TYPES = [INVENTORY_TYPE, NON_INVENTORY_TYPE, SERVICE_TYPE, CATEGORY_TYPE]

      xml_name 'Item'
      xml_accessor :id, :from => 'Id'
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :name, :from => 'Name'
      xml_accessor :sku, :from => 'Sku'
      xml_accessor :description, :from => 'Description'
      xml_accessor :active?, :from => 'Active'
      xml_accessor :sub_item?, :from => 'SubItem'
      xml_accessor :parent_ref, :from => 'ParentRef', :as => Integer
      xml_accessor :level, :from => 'Level', :as => Integer
      xml_accessor :pref_vendor_ref, :from => 'PrefVendorRef', :as => BaseReference
      xml_accessor :tax_classification_ref, :from => 'TaxClassificationRef', :as => BaseReference

      # read-only
      xml_accessor :fully_qualified_name, :from => 'FullyQualifiedName'
      xml_accessor :taxable?, :from => 'Taxable'
      xml_accessor :sales_tax_included?, :from => 'SalesTaxIncluded'
      xml_accessor :unit_price, :from => 'UnitPrice', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :rate_percent, :from => 'RatePercent', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :type, :from => 'Type'
      xml_accessor :income_account_ref, :from => 'IncomeAccountRef', :as => BaseReference
      xml_accessor :purchase_desc, :from => 'PurchaseDesc'
      xml_accessor :purchase_tax_included?, :from => 'PurchaseTaxIncluded'
      xml_accessor :purchase_cost, :from => 'PurchaseCost', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :expense_account_ref, :from => 'ExpenseAccountRef', :as => BaseReference
      xml_accessor :asset_account_ref, :from => 'AssetAccountRef', :as => BaseReference
      xml_accessor :track_quantity_on_hand?, :from => 'TrackQtyOnHand'
      xml_accessor :quantity_on_hand, :from => 'QtyOnHand', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :sales_tax_code_ref, :from => 'SalesTaxCodeRef', :as => BaseReference
      xml_accessor :purchase_tax_code_ref, :from => 'PurchaseTaxCodeRef', :as => BaseReference
      xml_accessor :inv_start_date, :from => 'InvStartDate', :as => Date
      xml_accessor :custom_fields, :from => "CustomField", as: [CustomField]
      xml_accessor :print_grouped_items?, :from => 'PrintGroupedItems'


      xml_accessor :item_group_details, :from => 'ItemGroupDetail', :as => ItemGroupDetail

      reference_setters :parent_ref, :income_account_ref, :expense_account_ref
      reference_setters :asset_account_ref, :sales_tax_code_ref, :purchase_tax_code_ref
      reference_setters :pref_vendor_ref, :tax_classification_ref

      #== Validations
      validates_length_of :name, :minimum => 1
      validates_inclusion_of :type, :in => ITEM_TYPES

      def initialize(*args)
        self.type = INVENTORY_TYPE
        super
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
