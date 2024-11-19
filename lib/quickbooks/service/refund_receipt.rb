module Quickbooks
  module Service
    class RefundReceipt < BaseService

      def delete(refund_receipt)
        delete_by_query_string(refund_receipt)
      end

      def pdf(refund_receipt)
        url = "#{url_for_resource(model::REST_RESOURCE)}/#{refund_receipt.id}/pdf"
        response = do_http_raw_get(url, {}, {'Accept' => 'application/pdf'})
        response.plain_body
      end

      private

      def model
        Quickbooks::Model::RefundReceipt
      end
    end
  end
end
