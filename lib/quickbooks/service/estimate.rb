module Quickbooks
  module Service
    class Estimate < BaseService

      def delete(estimate)
        delete_by_query_string(estimate)
      end
      
      def pdf(estimate)
        url = "#{url_for_resource(model::REST_RESOURCE)}/#{estimate.id}/pdf"
        response = do_http_raw_get(url, {}, {'Accept' => 'application/pdf'})
        response.plain_body
      end

      private

      def model
        Quickbooks::Model::Estimate
      end
    end
  end
end
