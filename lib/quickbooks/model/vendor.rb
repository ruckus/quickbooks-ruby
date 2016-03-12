# == Business Rules
# * The DisplayName, GivenName, MiddleName, FamilyName, and PrintOnCheckName attributes must not contain a colon,":".
# * The DisplayName attribute must be unique across all other customers, employees, vendors, and other names.
# * The PrimaryEmailAddress attribute must contain an at sign, "@," and dot, ".".
# * Either the DisplayName attribute or at least one of Title, GivenName, MiddleName, FamilyName, Suffix, or FullyQualifiedName attributes are required during create.

module Quickbooks
  module Model
    class Vendor < BaseModel
      XML_COLLECTION_NODE = "Vendor"
      XML_NODE = "Vendor"
      REST_RESOURCE = 'vendor'
      include NameEntity::Quality
      include NameEntity::PermitAlterations

      xml_name XML_NODE
      xml_accessor :id, :from => 'Id'
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :attachable_ref, :from => 'AttachableRef', :as => BaseReference
      xml_accessor :title, :from => 'Title'
      xml_accessor :given_name, :from => 'GivenName'
      xml_accessor :middle_name, :from => 'MiddleName'
      xml_accessor :family_name, :from => 'FamilyName'
      xml_accessor :suffix, :from => 'Suffix'
      xml_accessor :company_name, :from => 'CompanyName'
      xml_accessor :display_name, :from => 'DisplayName'
      xml_accessor :print_on_check_name, :from => 'PrintOnCheckName'
      xml_accessor :active?, :from => 'Active'
      xml_accessor :primary_phone, :from => 'PrimaryPhone', :as => TelephoneNumber
      xml_accessor :alternate_phone, :from => 'AlternatePhone', :as => TelephoneNumber
      xml_accessor :mobile_phone, :from => 'Mobile', :as => TelephoneNumber
      xml_accessor :fax_phone, :from => 'Fax', :as => TelephoneNumber
      xml_accessor :primary_email_address, :from => 'PrimaryEmailAddr', :as => EmailAddress
      xml_accessor :web_site, :from => 'WebAddr', :as => WebSiteAddress
      xml_accessor :billing_address, :from => 'BillAddr', :as => PhysicalAddress
      xml_accessor :other_contact_info, :from => 'OtherContactInfo', :as => OtherContactInfo
      xml_accessor :tax_identifier, :from => 'TaxIdentifier'
      xml_accessor :term_ref, :from => 'TermRef', :as => BaseReference
      xml_accessor :balance, :from => 'Balance', :as => BigDecimal, :to_xml => Proc.new { |val| val.to_f }
      xml_accessor :account_number, :from => 'AcctNum'
      xml_accessor :is_1099?, :from => 'Vendor1099'
      xml_accessor :currency_ref, :from => 'CurrencyRef', :as => BaseReference

      #== Validations
      validate :names_cannot_contain_invalid_characters
      validate :email_address_is_valid

      reference_setters

    end
  end
end
