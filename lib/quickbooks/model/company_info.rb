module Quickbooks
  module Model
    class CompanyInfo < BaseModel
      XML_COLLECTION_NODE = "CompanyInfo"
      XML_NODE = "CompanyInfo"
      REST_RESOURCE = 'companyinfo'

      xml_name XML_NODE
      xml_accessor :id, :from => 'Id'
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :company_name, :from => 'CompanyName'
      xml_accessor :legal_name, :from => 'LegalName'
      xml_accessor :company_address, :from => 'CompanyAddr', :as => PhysicalAddress
      xml_accessor :customer_communication_address, :from => 'CustomerCommunicationAddr', :as => PhysicalAddress
      xml_accessor :legal_address, :from => 'LegalAddr', :as => PhysicalAddress
      xml_accessor :primary_phone, :from => 'PrimaryPhone', :as => TelephoneNumber
      xml_accessor :company_start_date, :from => 'CompanyStartDate', :as => DateTime
      xml_accessor :employer_id, :from => 'EmployerId'
      xml_accessor :fiscal_year_start_month, :from => 'FiscalYearStartMonth'
      xml_accessor :country, :from => 'Country'
      xml_accessor :email, :from => 'Email', :as => EmailAddress
      xml_accessor :web_site, :from => 'WebAddr', :as => WebSiteAddress
      xml_accessor :supported_languages, :from => 'SupportedLanguages'
      xml_accessor :name_values, :from => 'NameValue', :as => [NameValue]

      def find_name_value(name)
        nv = name_values.find { |nv| nv.name == name }
        nv ? nv.value : nil
      end

      def find_boolean_name_value(name)
        find_name_value(name) == "true"
      end

      def industry_type
        find_name_value("IndustryType")
      end

      def industry_code
        find_name_value("IndustryCode")
      end

      def company_type
        find_name_value("CompanyType")
      end

      def subscription_status
        find_name_value("SubscriptionStatus")
      end

      def offering_sku
        find_name_value("OfferingSku")
      end

      def neo_enabled
        find_boolean_name_value("NeoEnabled")
      end

      def payroll_feature
        find_boolean_name_value("PayrollFeature")
      end

      def accountant_feature
        find_boolean_name_value("AccountantFeature")
      end
    end
  end
end
