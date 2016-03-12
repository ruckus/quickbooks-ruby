require 'quickbooks/model/attachable_ref'

module Quickbooks
  module Model
    class Attachable < BaseModel

      XML_COLLECTION_NODE = "Attachable"
      XML_NODE = "Attachable"
      REST_RESOURCE = 'attachable'

      xml_accessor :id, :from => 'Id'
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :attachable_ref, :as => AttachableRef
      xml_accessor :file_name
      xml_accessor :file_access_uri
      xml_accessor :temp_download_uri
      xml_accessor :size
      xml_accessor :content_type
      xml_accessor :category
      xml_accessor :lat
      xml_accessor :long
      xml_accessor :place_name
      xml_accessor :note
      xml_accessor :tag
      xml_accessor :thumbnail_file_access_uri
      xml_accessor :thumbnail_temp_download_uri

      reference_setters :attachable_ref

    end
  end
end
