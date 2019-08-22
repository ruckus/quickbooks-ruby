module Quickbooks
  module Service
    class Invoice < BaseService

      def delete(invoice)
        delete_by_query_string(invoice)
      end

      def url_for_resource(resource)
        url = super(resource)
      end

      def fetch_by_id(id, params = {})
        url = "#{url_for_base}/invoice/#{id}?minorversion=#{Quickbooks::Model::Invoice::MINORVERSION}"
        fetch_object(model, url, params)
      end

      def url_for_query(query = nil, start_position = 1, max_results = 20, options = {})
        url = super(query, start_position, max_results, options)
        "#{url}&minorversion=#{Quickbooks::Model::Invoice::MINORVERSION}"
      end

      def send(invoice, email_address=nil)
        query = email_address.present? ? "?sendTo=#{email_address}" : ""
        url = "#{url_for_resource(model::REST_RESOURCE)}/#{invoice.id}/send#{query}"
        response = do_http_post(url, "", {}, { 'Content-Type' => 'application/octet-stream' })
        if response.code.to_i == 200
          model.from_xml(parse_singular_entity_response(model, response.plain_body))
        else
          nil
        end
      end

      def pdf(invoice)
        url = "#{url_for_resource(model::REST_RESOURCE)}/#{invoice.id}/pdf"
        response = do_http_raw_get(url, {}, {'Accept' => 'application/pdf'})
        response.plain_body
      end

      def void(invoice, options = {})
        url = "#{url_for_resource(model::REST_RESOURCE)}?operation=void"

        xml = invoice.to_xml_ns(options)
        response = do_http_post(url, valid_xml_document(xml))
        if response.code.to_i == 200
          model.from_xml(parse_singular_entity_response(model, response.plain_body))
        else
          false
        end
      end

      private

      def model
        Quickbooks::Model::Invoice
      end
    end
  end
end
