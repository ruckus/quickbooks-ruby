module Quickbooks
  module Model
    class Class < BaseModel
      XML_COLLECTION_NODE = "Class"
      XML_NODE = "Class"
      REST_RESOURCE = 'class'
      include NameEntity::Quality
      include NameEntity::PermitAlterations

      xml_name XML_NODE
      xml_accessor :id, :from => 'Id'
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :name, :from => 'Name'
      xml_accessor :sub_class, :from => 'SubClass'
      xml_accessor :parent_ref, :from => 'ParentRef', :as => BaseReference
      xml_accessor :fully_qualified_name, :from => 'FullyQualifiedName' # ReadOnly
      xml_accessor :active?, :from => 'Active'

      reference_setters :parent_ref

      #== Validations
      validate :names_cannot_contain_invalid_characters

      def sub_class?
        sub_class.to_s == 'true'
      end

    end
  end
end
