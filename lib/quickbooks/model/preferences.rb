module Quickbooks
  module Model
    class Preferences < BaseModel
      XML_COLLECTION_NODE = "Preferences"
      XML_NODE            = "Preferences"
      REST_RESOURCE       = 'preferences'
      MINORVERSION = 32

      xml_name XML_NODE

      def self.create_preference_class(*attrs, &block)
        ::Class.new(BaseModel) do
          attrs.each do |a|
            xml_reader(a.underscore, :from => a.gsub("?", ""))
          end
          instance_eval(&block) if block_given?
        end
      end

      PREFERENCE_SECTIONS = {
        :accounting_info      => %w(TrackDepartments DepartmentTerminology ClassTrackingPerTxnLine? ClassTrackingPerTxn? CustomerTerminology),
        :product_and_services => %w(ForSales? ForPurchase? QuantityWithPriceAndRate? QuantityOnHand?),
        :vendor_and_purchase  => %w(TrackingByCustomer? BillableExpenseTracking? DefaultTerms? DefaultMarkup? POCustomField),
        :time_tracking        => %w(UseServices? BillCustomers? ShowBillRateToAll WorkWeekStartDate MarkTimeEntiresBillable?),
        :tax                  => %w(UsingSalesTax? PartnerTaxEnabled?),
        :currency             => %w(MultiCurrencyEnabled? HomeCurrency),
        :report               => %w(ReportBasis)
      }

      xml_reader :sales_forms, :from => "SalesFormsPrefs", :as => create_preference_class(*%w(
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
        xml_reader :custom_fields, :as => [CustomField], :from => 'CustomField', in: 'CustomField'
      }

      PREFERENCE_SECTIONS.each do |section_name, fields|
        xml_reader section_name, :from => "#{section_name}_prefs".camelize, :as => create_preference_class(*fields)
      end

      EmailMessage          = create_preference_class("Subject", "Message")
      EmailMessageContainer = create_preference_class do
        %w(InvoiceMessage EstimateMessage SalesReceiptMessage StatementMessage).each do |msg|
          xml_reader msg.underscore, :from => msg, :as => EmailMessage
        end
      end

      xml_reader :email_messages, :from => "EmailMessagesPrefs", as: EmailMessageContainer

      xml_reader :other_prefs, :from => "OtherPrefs/NameValue", :as => { :key => "Name", :value => "Value" }
    end

  end
end
