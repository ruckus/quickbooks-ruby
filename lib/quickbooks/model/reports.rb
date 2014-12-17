module Quickbooks
  module Model
    class Reports < BaseModel
      XML_COLLECTION_NODE = "Reports"
      XML_NODE = "Reports"
      REST_RESOURCE = 'reports'

      REPORTS = ['BalanceSheet', 'ProfitandLoss', 'ProfitandLossDetail', 'CashFlow']

      xml_name XML_NODE

      xml_accessor :currency, :from => 'Currency'

    end
  end
end