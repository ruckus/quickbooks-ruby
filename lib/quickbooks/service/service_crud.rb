module Quickbooks
  module Service
    module ServiceCrud

      def query(object_query = nil, options = {})
        fetch_collection(object_query, model, options)
      end

      def fetch_by_id(id, options = {})
        url = "#{url_for_resource(model.resource_for_singular)}/#{id}"
        fetch_object(model, url, options)
      end

      def create(entity, options = {})
        raise InvalidModelException.new(entity.errors.full_messages.join(',')) unless entity.valid?
        xml = entity.to_xml_ns(options)
        response = do_http_post(url_for_resource(model.resource_for_singular), valid_xml_document(xml))
        if response.code.to_i == 200
          model.from_xml(parse_singular_entity_response(model, response.plain_body))
        else
          nil
        end
      end

      def delete(entity)
        raise "Not implemented for this Entity"
      end

      def delete_by_query_string(entity, options = {})
        url = "#{url_for_resource(model::REST_RESOURCE)}?operation=delete"

        xml = entity.to_xml_ns(options)
        response = do_http_post(url, valid_xml_document(xml))
        if response.code.to_i == 200
          parse_singular_entity_response_for_delete(model, response.plain_body)
        else
          false
        end
      end

      def update(entity, options = {})
        unless entity.valid?
          raise InvalidModelException.new(entity.errors.full_messages.join(','))
        end

        xml = entity.to_xml_ns(options)
        response = do_http_post(url_for_resource(model.resource_for_singular), valid_xml_document(xml))
        if response.code.to_i == 200
          model.from_xml(parse_singular_entity_response(model, response.plain_body))
        else
          nil
        end
      end

    end
  end
end
