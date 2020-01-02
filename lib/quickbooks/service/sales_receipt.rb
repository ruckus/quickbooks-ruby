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

      def send(sr, email_address=nil)
        query = email_address.present? ? "?sendTo=#{email_address}" : ""
        url = "#{url_for_resource(model::REST_RESOURCE)}/#{sr.id}/send#{query}"
        response = do_http_post(url, "", {}, { 'Content-Type' => 'application/octet-stream' })
        if response.code.to_i == 200
          model.from_xml(parse_singular_entity_response(model, response.plain_body))
        else
          nil
        end
      end

      def void(sales_receipt, options = {})
        raise Quickbooks::InvalidModelException.new(sales_receipt.errors.full_messages.join(',')) unless sales_receipt.valid?
        xml = sales_receipt.to_xml_ns(options)
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
        Quickbooks::Model::SalesReceipt
      end
    end
  end
end
