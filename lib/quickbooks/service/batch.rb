module Quickbooks
  module Service
    class Batch < BaseService

      def make_request(entity, options = {})
        response = do_http_post(url_for_resource('batch'), valid_xml_document(entity.to_xml_ns), options[:query])
        Quickbooks::Model::BatchResponse.from_xml(response.plain_body)
      end
    end
  end
end
