module Quickbooks
  module Model
    class Budget < BaseModel
      include HasLineItems

      XML_COLLECTION_NODE = "Budget"
      XML_NODE = "Budget"
      REST_RESOURCE = 'budget'

      xml_name XML_NODE

      xml_accessor :id, :from => 'Id'
      xml_accessor :name, :from => 'Name'
      xml_accessor :type, :from => 'BudgetType'
      xml_accessor :entry_type, :from => 'BudgetEntryType'
      xml_accessor :start_date, :from => 'StartDate'
      xml_accessor :end_date, :from => 'EndDate'
      xml_accessor :active?, :from => 'Active'
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData

      xml_accessor :line_items, :from => 'BudgetDetail', :as => [BudgetLineItem]

      reference_setters
    end
  end
end
