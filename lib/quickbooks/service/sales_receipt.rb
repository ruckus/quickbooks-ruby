module Quickbooks
  module Service
    class SalesReceipt < BaseService

      def delete(sales_receipt)
        delete_by_query_string(sales_receipt)
      end

      def pdf(sales_receipt)
        url = "#{url_for_resource(model::REST_RESOURCE)}/#{sales_receipt.id}/pdf"
        response = do_http_raw_get(url, {}, {'Accept' => 'application/pdf'})
        response.plain_body
      end

      private

      def model
        Quickbooks::Model::SalesReceipt
      end
    end
  end
end
