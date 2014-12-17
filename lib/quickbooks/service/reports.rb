module Quickbooks
  module Service
    class Reports < BaseService

      private
      
      def model
        Quickbooks::Model::Reports
      end

      def url_for_query(query = nil, start_position = 1, max_results = 20)
        query ||= default_model_query
        query = "#{query} STARTPOSITION #{start_position} MAXRESULTS #{max_results}"

        "#{url_for_base}/reports/BalanceSheet?date_macro='This Fiscal Year-to-date'"
      end
    end
  end
end