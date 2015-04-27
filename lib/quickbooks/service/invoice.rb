module Quickbooks
  module Service
    class Invoice < BaseService

      def delete(invoice)
        delete_by_query_string(invoice)
      end

      def send(invoice, email_address=nil)
        query = email_address.present? ? "?sendTo=#{email_address}" : ""
        url = "#{url_for_resource(model::REST_RESOURCE)}/#{invoice.id}/send#{query}"
        response = do_http_post(url,{})
        if response.code.to_i == 200
          model.from_xml(parse_singular_entity_response(model, response.plain_body))
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
