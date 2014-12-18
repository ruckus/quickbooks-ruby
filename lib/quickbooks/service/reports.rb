module Quickbooks
  module Service
    class Reports < BaseService

      def url_for_query(which_report = 'BalanceSheet', date_macro = 'This Fiscal Year-to-date')
        "#{url_for_base}/reports/#{which_report}?date_macro=#{URI.encode_www_form_component(date_macro)}"
      end

      def fetch_collection(model, date_macro, object_query)
        response = do_http_get(url_for_query(object_query, date_macro))

        parse_collection(response, model)

      end

      def query(object_query = 'BalanceSheet', date_macro = 'This Fiscal Year-to-date')
        fetch_collection(model, date_macro , object_query)
      end

      private
      
      def model
        Quickbooks::Model::Reports
      end

    end
  end
end