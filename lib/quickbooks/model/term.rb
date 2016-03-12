module Quickbooks
  module Model
    class Term < BaseModel
      XML_COLLECTION_NODE = "Term"
      XML_NODE = "Term"
      REST_RESOURCE = 'term'

      xml_accessor :id, :from => 'Id'
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :name, :from => 'Name'
      xml_accessor :active?, :from => 'Active'
      xml_accessor :type, :from => 'Type'
      xml_accessor :discount_percent, :from => 'DiscountPercent', :as => BigDecimal
      xml_accessor :due_days, :from => 'DueDays', :as => Integer
      xml_accessor :discount_days, :from => 'DiscountDays', :as => Integer
      xml_accessor :day_of_month_due, :from => 'DayOfMonthDue', :as => Integer
      xml_accessor :due_next_month_days, :from => 'DueNextMonthDays', :as => Integer
      xml_accessor :discount_day_of_month, :from => 'DiscountDayOfMonth', :as => Integer
      xml_accessor :attachable_ref, :from => 'AttachableRef', :as => BaseReference

      validates_presence_of :name

      reference_setters :attachable_ref

    end
  end
end
