module Quickbooks
  module Model
    class Reports < BaseModel
      XML_COLLECTION_NODE = "Reports"
      XML_NODE = "Reports"
      REST_RESOURCE = 'reports'

      REPORT_TYPES = ['BalanceSheet', 'ProfitandLoss', 'ProfitAndLossDetail', 'TrialBalance', 'CashFlow', 'InventoryValuationSummary', 'CustomerSales', 'ItemSales', 'DepartmentSales', 'ClassSales', 'CustomerIncome', 'CustomerBalance', 'CustomerBalanceDetail', 'AgedReceivables', 'AgedReceivableDetail', 'VendorBalance', 'VendorBalanceDetail', 'AgedPayables', 'AgedPayableDetail', 'VendorExpenses', 'GeneralLedgerDetail']

      xml_name XML_NODE

      xml_accessor :currency, :from => 'Header/Currency'
      xml_accessor :body

    end
  end
end
