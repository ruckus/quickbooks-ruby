module Quickbooks
  module Service
    class Payment < BaseService

      def delete(payment)
        delete_by_query_string(payment)
      end

      def void(entity, options = {})
        raise Quickbooks::InvalidModelException.new(entity.errors.full_messages.join(',')) unless entity.valid?
        xml = entity.to_xml_ns(options)
        url = "#{url_for_resource(model::REST_RESOURCE)}?include=void"

        response = do_http_post(url, valid_xml_document(xml), {})
        if response.code.to_i == 200
          model.from_xml(parse_singular_entity_response(model, response.plain_body))
        else
          false
        end
      end

      private

      def model
        Quickbooks::Model::Payment
      end
    end
  end
end
