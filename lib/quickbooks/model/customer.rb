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
      include NameEntity::Quality
      include NameEntity::PermitAlterations

      MINORVERSION = 33

      xml_name XML_NODE
      xml_accessor :id, :from => 'Id'
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :title, :from => 'Title'
      xml_accessor :given_name, :from => 'GivenName'
      xml_accessor :middle_name, :from => 'MiddleName'
      xml_accessor :family_name, :from => 'FamilyName'
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
      xml_accessor :shipping_address, :from => 'ShipAddr', :as => PhysicalAddress
      xml_accessor :job, :from => 'Job'
      xml_accessor :bill_with_parent, :from => 'BillWithParent'
      xml_accessor :parent_ref, :from => 'ParentRef', :as => BaseReference
      xml_accessor :level, :from => 'Level'
      xml_accessor :sales_term_ref, :from => 'SalesTermRef', :as => BaseReference
      xml_accessor :payment_method_ref, :from => 'PaymentMethodRef', :as => BaseReference
      xml_accessor :balance, :from => 'Balance', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :open_balance_date, :from => 'OpenBalanceDate', :as => Date
      xml_accessor :balance_with_jobs, :from => 'BalanceWithJobs', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :preferred_delivery_method, :from => 'PreferredDeliveryMethod'
      xml_accessor :resale_num, :from => 'ResaleNum'
      xml_accessor :suffix, :from => 'Suffix'
      xml_accessor :fully_qualified_name, :from => 'FullyQualifiedName'
      xml_accessor :taxable, :from => 'Taxable'
      xml_accessor :default_tax_code_ref, :from => 'DefaultTaxCodeRef', :as => BaseReference
      xml_accessor :notes, :from => 'Notes'
      xml_accessor :currency_ref, :from => 'CurrencyRef', :as => BaseReference
      xml_accessor :tax_exemption_reason_id, :from => 'TaxExemptionReasonId'
      xml_accessor :primary_tax_identifier, :from => 'PrimaryTaxIdentifier'
      xml_accessor :customer_type_ref, :from => 'CustomerTypeRef', :as => BaseReference

      #== Validations
      validate :names_cannot_contain_invalid_characters
      validate :email_address_is_valid

      reference_setters :parent_ref, :sales_term_ref, :payment_method_ref, :default_tax_code_ref, :currency_ref,
                        :customer_type_ref

      def job?
        job.to_s == 'true'
      end

      def bill_with_parent?
        bill_with_parent.to_s == 'true'
      end

      def taxable?
        taxable.to_s == 'true'
      end
    end
  end
end
