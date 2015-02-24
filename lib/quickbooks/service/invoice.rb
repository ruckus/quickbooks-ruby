module Quickbooks
  module Service
    class Invoice < BaseService

      def delete(invoice)
        delete_by_query_string(invoice)
      end

      def send(invoice, emailAddress=nil)
        url = "#{url_for_base}/invoice/#{invoice.id}/send"
        url = "#{url}?sendTo=emailAddress" if emailAddress.present?
        response = do_http_post(url, {}, {}, {})
      end

      private

      def model
        Quickbooks::Model::Invoice
      end
    end
  end
end
