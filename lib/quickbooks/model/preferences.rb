module Quickbooks
  module Model
    class Preferences < BaseModel
      XML_COLLECTION_NODE = "Preferences"
      XML_NODE            = "Preferences"
      REST_RESOURCE       = 'preferences'

      xml_name XML_NODE
      xml_accessor :id, :from => 'Id'
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer

      def self.create_preference_class(*attrs, &block)
        ::Class.new(BaseModel) do
          attrs.each do |a|
            xml_accessor(a.underscore, :from => a.gsub("?", ""))
          end
          instance_eval(&block) if block_given?
        end
      end

      PREFERENCE_SECTIONS = {
        :accounting_info      => %w(TrackDepartments DepartmentTerminology ClassTrackingPerTxnLine? ClassTrackingPerTxn? CustomerTerminology),
        :product_and_services => %w(ForSales? ForPurchase? QuantityWithPriceAndRate? QuantityOnHand?),
        :time_tracking        => %w(UseServices? BillCustomers? ShowBillRateToAll WorkWeekStartDate MarkTimeEntiresBillable?),
        :tax                  => %w(UsingSalesTax? PartnerTaxEnabled?),
        :currency             => %w(MultiCurrencyEnabled? HomeCurrency),
        :report               => %w(ReportBasis)
      }

      xml_accessor :sales_forms, :from => "SalesFormsPrefs", :as => create_preference_class(*%w(
        AllowDeposit?
        AllowDiscount?
        AllowEstimates?
        AllowServiceDate?
        AllowShipping?
        AutoApplyCredit?
        CustomField?
        CustomTxnNumbers?
        DefaultCustomerMessage
        DefaultDiscountAccount?
        DefaultShippingAccount?
        DefaultTerms
        EmailCopyToCompany?
        EstimateMessage
        ETransactionAttachPDF?
        ETransactionEnabledStatus
        ETransactionPaymentEnabled?
        IPNSupportEnabled?
        SalesEmailBcc
        SalesEmailCc
        UsingPriceLevels?
        UsingProgressInvoicing?
      )) {
        xml_name "SalesFormsPrefs"
        # xml_reader :custom_fields, :as => [CustomField], :from => 'CustomField', in: 'CustomField'
      }

      xml_reader :vendor_and_purchases, :from => "VendorAndPurchasesPrefs", :as => create_preference_class(*%w(
        TrackingByCustomer?
        BillableExpenseTracking?
        DefaultTerms?
        DefaultMarkup?
      )) {
        xml_name "VendorAndPurchasesPrefs"
        # xml_reader :po_custom_fields, :as => [CustomField], :from => 'CustomField', in: 'POCustomField'
      }

      PREFERENCE_SECTIONS.each do |section_name, fields|
        xml_reader section_name, :from => "#{section_name}_prefs".camelize, :as => create_preference_class(*fields) { xml_name "#{section_name}_prefs" }
      end

      EmailMessage          = create_preference_class("Subject", "Message") { xml_name "EmailMessage" }
      EmailMessageContainer = create_preference_class do
        xml_name "EmailMessageContainer"
        %w(InvoiceMessage EstimateMessage SalesReceiptMessage StatementMessage).each do |msg|
          xml_reader msg.underscore, :from => msg, :as => EmailMessage
        end
      end

      xml_reader :email_messages, :from => "EmailMessagesPrefs", as: EmailMessageContainer

      OtherPrefs = create_preference_class do
        xml_name "OtherPrefs"
        xml_reader :name_values, :from => 'NameValue', :as => { :key => "Name", :value => "Value" }
      end
      xml_reader :other_prefs, :from => "OtherPrefs", :as => OtherPrefs
    end

  end
end
