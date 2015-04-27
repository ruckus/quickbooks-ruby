# == Business Rules
# * DisplayName, GivenName, MiddleName, FamilyName, and PrintOnCheckName must not contain a colon (":")
# * DisplayName must be unique across all other customers, employees, vendors, and other names.

module Quickbooks
  module Model
    class Employee < BaseModel
      XML_COLLECTION_NODE = "Employee"
      XML_NODE = "Employee"
      REST_RESOURCE = 'employee'
      include NameEntity::Quality
      include NameEntity::PermitAlterations

      xml_name XML_NODE
      xml_accessor :id, :from => 'Id'
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :organization?, :from => 'Organization'
      xml_accessor :title, :from => 'Title'
      xml_accessor :given_name, :from => 'GivenName'
      xml_accessor :middle_name, :from => 'MiddleName'
      xml_accessor :family_name, :from => 'FamilyName'
      xml_accessor :suffix, :from => 'Suffix'
      xml_accessor :display_name, :from => 'DisplayName'
      xml_accessor :print_on_check_name, :from => 'PrintOnCheckName'
      xml_accessor :active?, :from => 'Active'
      xml_accessor :primary_phone, :from => 'PrimaryPhone', :as => TelephoneNumber
      xml_accessor :mobile_phone, :from => 'Mobile', :as => TelephoneNumber
      xml_accessor :primary_email_address, :from => 'PrimaryEmailAddr', :as => EmailAddress
      xml_accessor :number, :from => 'EmployeeNumber'
      xml_accessor :ssn, :from => 'SSN'
      xml_accessor :address, :from => 'PrimaryAddr', :as => PhysicalAddress
      xml_accessor :billable?, :from => 'BillableTime'
      xml_accessor :billable_rate, :from => 'BillRate', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :birth_date, :from => 'BirthDate', :as => Date
      xml_accessor :gender, :from => 'Gender'
      xml_accessor :hired_date, :from => 'HiredDate', :as => Date
      xml_accessor :released_date, :from => 'ReleasedDate', :as => Date

      #== Validations
      validate :names_cannot_contain_invalid_characters
      validate :email_address_is_valid


    end
  end
end
