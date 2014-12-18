module Quickbooks
  module Service
    class Reports < BaseService

      def url_for_query(which_report = 'BalanceSheet', date_macro = 'This Fiscal Year-to-date')
        "#{url_for_base}/reports/#{which_report}?date_macro=#{URI.encode_www_form_component(date_macro)}"
      end

      def fetch_collection(model, options = {}, object_query)
        page = options.fetch(:page, 1)
        per_page = options.fetch(:per_page, 20)

        start_position = ((page - 1) * per_page) + 1 # page=2, per_page=10 then we want to start at 11
        max_results = per_page

        response = do_http_get(url_for_query(object_query))

        parse_collection(response, model)

      end

      def query(object_query = 'BalanceSheet', options = {})
        fetch_collection(model, options, object_query)
      end

      private
      
      def model
        Quickbooks::Model::Reports
      end

    end
  end
end