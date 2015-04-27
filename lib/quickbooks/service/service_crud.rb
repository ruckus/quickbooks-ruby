module Quickbooks
  module Service
    module ServiceCrud

      def query(object_query = nil, options = {})
        fetch_collection(object_query, model, options)
      end

      def query_in_batches(object_query=nil, options={})
        page = 0
        per_page = options.delete(:per_page) || 1_000
        begin
          page += 1
          results = query(object_query, page: page, per_page: per_page)
          yield results if results.count > 0
        end until results.count < per_page
      end

      def fetch_by_id(id, params = {})
        url = "#{url_for_resource(model.resource_for_singular)}/#{id}"
        fetch_object(model, url, params)
      end

      def create(entity, options = {})
        raise Quickbooks::InvalidModelException.new(entity.errors.full_messages.join(',')) unless entity.valid?
        xml = entity.to_xml_ns(options)
        response = do_http_post(url_for_resource(model.resource_for_singular), valid_xml_document(xml))
        if response.code.to_i == 200
          model.from_xml(parse_singular_entity_response(model, response.plain_body))
        else
          nil
        end
      end
      alias :update :create

      def delete(entity)
        raise NotImplementedError
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
    end
  end
end
