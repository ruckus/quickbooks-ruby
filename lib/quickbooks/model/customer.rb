# == Business Rules
# * The DisplayName, GivenName, MiddleName, FamilyName, and PrintOnCheckName attributes must not contain a colon,":".
# * The DisplayName attribute must be unique across all other customers, employees, vendors, and other names.
# * The PrimaryEmailAddress attribute must contain an at sign, "@," and dot, ".".
# * Nested customer objects can be used to define sub-customers, jobs, or a combination of both, under a parent.
# * Up to four levels of nesting can be defined under a top-level customer object.
# * The Job attribute defines whether the object is a top-level customer or nested sub-customer/job.
# * Either the DisplayName attribute or at least one of Title, GivenName, MiddleName, FamilyName, Suffix, or FullyQualifiedName attributes are required during create.

module Quickbooks
  module Model
    class Customer < BaseModel
      XML_COLLECTION_NODE = "Customer"
      XML_NODE = "Customer"
      REST_RESOURCE = 'customer'

      xml_name XML_NODE
      xml_accessor :id, :from => 'Id', :as => Integer
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => Quickbooks::Model::MetaData
      xml_accessor :title, :from => 'Title'
      xml_accessor :given_name, :from => 'GivenName'
      xml_accessor :middle_name, :from => 'MiddleName'
      xml_accessor :family_name, :from => 'FamilyName'
      xml_accessor :company_name, :from => 'CompanyName'
      xml_accessor :display_name, :from => 'DisplayName'
      xml_accessor :print_on_check_name, :from => 'PrintOnCheckName'
      xml_accessor :active, :from => 'Active'
      xml_accessor :primary_phone, :from => 'PrimaryPhone', :as => Quickbooks::Model::TelephoneNumber
      xml_accessor :alternate_phone, :from => 'AlternatePhone', :as => Quickbooks::Model::TelephoneNumber
      xml_accessor :mobile_phone, :from => 'Mobile', :as => Quickbooks::Model::TelephoneNumber
      xml_accessor :fax_phone, :from => 'Fax', :as => Quickbooks::Model::TelephoneNumber
      xml_accessor :primary_email_address, :from => 'PrimaryEmailAddr', :as => Quickbooks::Model::EmailAddress
      xml_accessor :web_site, :from => 'WebAddr', :as => Quickbooks::Model::WebSiteAddress
      xml_accessor :billing_address, :from => 'BillAddr', :as => Quickbooks::Model::PhysicalAddress
      xml_accessor :shipping_address, :from => 'ShipAddr', :as => Quickbooks::Model::PhysicalAddress
      xml_accessor :job, :from => 'Job'
      xml_accessor :bill_with_parent, :from => 'BillWithParent'
      xml_accessor :parent_ref, :from => 'ParentRef'
      xml_accessor :level, :from => 'Level'
      xml_accessor :sales_term_ref, :from => 'SalesTermRef'
      xml_accessor :payment_method_ref, :from => 'PaymentMethodRef'
      xml_accessor :balance, :from => 'Balance', :as => Float
      xml_accessor :open_balance_date, :from => 'OpenBalanceDate', :as => Date
      xml_accessor :balance_with_jobs, :from => 'BalanceWithJobs', :as => Float
      xml_accessor :preferred_delivery_method, :from => 'PreferredDeliveryMethod'
      xml_accessor :resale_num, :from => 'ResaleNum'
      xml_accessor :suffix, :from => 'Suffix'
      xml_accessor :fully_qualified_name, :from => 'FullyQualifiedName'
      xml_accessor :taxable, :from => 'Taxable'
      xml_accessor :notes, :from => 'Notes'

      validate :names_cannot_contain_invalid_characters
      validate :email_address_is_valid

      def active?
        active.to_s == 'true'
      end

      def job?
        job.to_s == 'true'
      end

      def bill_with_parent?
        bill_with_parent.to_s == 'true'
      end

      def taxable?
        taxable.to_s == 'true'
      end

      def valid_for_update?
        if sync_token.nil?
          errors.add(:sync_token, "Missing required attribute SyncToken for update")
        end
        errors.empty?
      end

      def valid_for_create?
        valid?
        errors.empty?
      end

      def email_address=(email_address)
        self.primary_email_address = Quickbooks::Model::EmailAddress.new(email_address)
      end

      def email_address
        primary_email_address
      end

      # To delete an account Intuit requires we provide Id and SyncToken fields
      def valid_for_deletion?
        return false if(id.nil? || sync_token.nil?)
        id.to_i > 0 && !sync_token.to_s.empty? && sync_token.to_i >= 0
      end

      def names_cannot_contain_invalid_characters
        [:display_name, :given_name, :middle_name, :family_name, :print_on_check_name].each do |property|
          value = send(property).to_s
          if value.index(':')
            errors.add(property, ":#{property} cannot contain a colon (:).")
          end
        end
      end

      def email_address_is_valid
        if primary_email_address
          address = primary_email_address.address
          unless address.index('@') && address.index('.')
            errors.add(:primary_email_address, "Email address must contain @ and . (dot)")
          end
        end
      end

    end
  end
end