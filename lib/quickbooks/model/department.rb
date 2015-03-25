module Quickbooks
  module Model
    class Department < BaseModel
      XML_COLLECTION_NODE = "Department"
      XML_NODE = "Department"
      REST_RESOURCE = 'department'
      include NameEntity::Quality
      include NameEntity::PermitAlterations

      xml_name XML_NODE
      xml_accessor :id, :from => 'Id'
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :name, :from => 'Name'
      xml_accessor :sub_department, :from => 'SubDepartment'
      xml_accessor :parent_ref, :from => 'ParentRef', :as => BaseReference
      xml_accessor :fully_qualified_name, :from => 'FullyQualifiedName' # ReadOnly
      xml_accessor :active?, :from => 'Active'

      reference_setters :parent_ref

      #== Validations
      validate :names_cannot_contain_invalid_characters

      def sub_department?
        sub_department.to_s == 'true'
      end

    end
  end
end
