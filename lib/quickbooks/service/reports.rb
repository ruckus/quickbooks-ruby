module Quickbooks
  module Service
    class Reports < BaseService

      private
      
      def model
        Quickbooks::Model::Reports
      end

      def url_for_query(date_macro = 'This Fiscal Year-to-date')
        "#{url_for_base}/reports/BalanceSheet?date_macro=#{URI.encode_www_form_component(date_macro)"
      end
    end
  end
end