module Quickbooks
  module Service
    class Invoice < BaseService

      def delete(invoice)
        delete_by_query_string(invoice)
      end

      def send(invoice, email_address=nil)
        query = email_address.present? ? "?sendTo=#{email_address}" : ""
        # url = "#{url_for_base}/invoice/#{invoice.id}/send#{email}"
        url = "#{url_for_resource(model::REST_RESOURCE)}/#{invoice.id}/send#{query}"
        do_http_post(url,{})
      end

      private

      def model
        Quickbooks::Model::Invoice
      end
    end
  end
end
