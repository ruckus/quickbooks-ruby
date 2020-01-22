module Quickbooks
  module Service
    class CreditMemo < BaseService

      def delete(credit_memo)
        delete_by_query_string(credit_memo)
      end

      def pdf(credit_memo)
        url = "#{url_for_resource(model::REST_RESOURCE)}/#{credit_memo.id}/pdf"
        response = do_http_raw_get(url, {}, {'Accept' => 'application/pdf'})
        response.plain_body
      end

      private

      def model
        Quickbooks::Model::CreditMemo
      end
    end
  end
end
