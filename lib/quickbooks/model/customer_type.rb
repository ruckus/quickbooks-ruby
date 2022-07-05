module Quickbooks
  module Model
    class CustomerType < BaseModel
      XML_COLLECTION_NODE = "CustomerType"
      XML_NODE = "CustomerType"
      REST_RESOURCE = 'customertype'

      xml_accessor :id, :from => 'Id'
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :name, :from => 'Name'
      xml_accessor :active?, :from => 'Active'
    end
  end
end
