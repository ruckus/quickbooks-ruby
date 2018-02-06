module Quickbooks
  module Model
    class TaxRate < BaseModel
      XML_COLLECTION_NODE = "TaxRate"
      XML_NODE = "TaxRate"
      REST_RESOURCE = "taxrate"

      xml_accessor :id, :from => "Id"
      xml_accessor :sync_token, :from => "SyncToken", :as => Integer
      xml_accessor :meta_data, :from => "MetaData", :as => MetaData
      xml_accessor :name, :from => "Name"
      xml_accessor :description, :from => "Description"
      xml_accessor :active?, :from => "Active"
      xml_accessor :rate_value, :from => "RateValue", :as => BigDecimal, :to_xml => :to_f.to_proc
      xml_accessor :agency_ref, :from => "AgencyRef", :as => BaseReference
      xml_accessor :tax_return_line_ref, :from => "TaxReturnLineRef", :as => BaseReference
      xml_accessor :special_tax_type, :from => "SpecialTaxType"
      xml_accessor :display_type, :from => "DisplayType"
      xml_accessor :effective_tax_rate, :from => "EffectiveTaxRate", :as => [EffectiveTaxRate]

      validates_presence_of :name, :rate_value

      reference_setters :agency_ref
      reference_setters :tax_return_line_ref

    end
  end
end
