module Quickbooks
  module Model
    class ExchangeRate < BaseModel
      XML_COLLECTION_NODE = "ExchangeRate"
      XML_NODE = "ExchangeRate"
      REST_RESOURCE = "exchangerate"

      xml_accessor :id, :from => "Id"
      xml_accessor :sync_token, :from => "SyncToken", :as => Integer
      xml_accessor :meta_data, :from => "MetaData", :as => MetaData

      xml_accessor :custom_fields, :from => 'CustomField', :as => [CustomField]
      xml_accessor :source_currency_code, :from => 'SourceCurrencyCode'
      xml_accessor :target_currency_code, :from => 'TargetCurrencyCode'
      xml_accessor :rate, :from => 'Rate', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :as_of_date, :from => 'AsOfDate', :as => Date

      validates_presence_of :source_currency_code, :rate, :as_of_date
      validates_length_of :source_currency_code, :is => 3
      validates_length_of :target_currency_code, :is => 3
    end
  end
end
