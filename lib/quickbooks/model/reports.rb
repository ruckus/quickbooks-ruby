module Quickbooks
  module Model
    class Reports < BaseModel
      XML_COLLECTION_NODE = "Report"
      XML_NODE = "Report"
      REST_RESOURCE = 'report'

      REPORTS = ['BalanceSheet', 'ProfitandLoss', 'ProfitandLossDetail', 'CashFlow']

      xml_name XML_NODE

      xml_accessor :currency, :from => 'Currency'


    end
  end
end