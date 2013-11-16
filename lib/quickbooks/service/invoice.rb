module Quickbooks
  module Service
    class Invoice < BaseService

      def query(invoice_query = nil, options = {})
        invoice_query ||= "SELECT * FROM INVOICE"

        options[:page] ||= 1
        options[:per_page] ||= 20
        fetch_collection(invoice_query, model, options)
      end

      def fetch_by_id(id, options = {})
        url = "#{url_for_resource(model.resource_for_singular)}/#{id}"
        fetch_object(model, url, options)
      end

      def create(object)
        raise InvalidModelException.new(object.errors.full_messages.join(',')) unless object.valid?
        xml = object.to_xml_ns
        response = do_http_post(url_for_resource(model.resource_for_singular), valid_xml_document(xml))
        if response.code.to_i == 200
          model.from_xml(parse_singular_entity_response(model, response.body))
        else
          nil
        end
      end

      private

      def model
        Quickbooks::Model::Invoice
      end
    end
  end
end