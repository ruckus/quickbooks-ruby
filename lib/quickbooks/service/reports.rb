# Docs: https://developer.intuit.com/docs/0100_accounting/0400_references/reports
module Quickbooks
  module Service
    class Reports < BaseService

      def url_for_query(which_report = 'BalanceSheet', date_macro = 'This Fiscal Year-to-date', options = {})
        if(options == {})
          return "#{url_for_base}/reports/#{which_report}?date_macro=#{URI.encode_www_form_component(date_macro)}"
        else
          options_string = ""
          options.each do |key, value|
            options_string += "#{key}=#{value}&"
          end
          options_string = options_string[0..-2]
          options_string.gsub!(/\s/,"%20")
          return "#{url_for_base}/reports/#{which_report}?#{options_string}"
        end
      end

      def query(object_query = 'BalanceSheet', date_macro = 'This Fiscal Year-to-date', options = {})
        do_http_get(url_for_query(object_query, date_macro, options))
        model.new(:xml => @last_response_xml)
      end

      private

      def model
        Quickbooks::Model::Report
      end

    end
  end
end
