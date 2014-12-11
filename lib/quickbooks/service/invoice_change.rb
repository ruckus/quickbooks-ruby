module Quickbooks
  module Service
    class InvoiceChange < BaseService
      
      def url_for_query(query = nil, start_position = 1, max_results = 20)
        q = "Invoice"
        q = "#{q}&#{query}" if query.present?

        "#{url_for_base}/cdc?entities=#{q}"
      end

      def since(timestamp)
        query("changedSince=#{URI.encode_www_form_component(timestamp.iso8601)}")
      end
      
      private
      
      def model
        Quickbooks::Model::InvoiceChange
      end
    end
  end
end
