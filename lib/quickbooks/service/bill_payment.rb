module Quickbooks
  module Service
    class BillPayment < BaseService

      def delete(bill_payment)
        delete_by_query_string(bill_payment)
      end

      def void(bill_payment, options = {})
        raise Quickbooks::InvalidModelException.new(bill_payment.errors.full_messages.join(',')) unless bill_payment.valid?

        xml = bill_payment.to_xml_ns(options)
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
        Quickbooks::Model::BillPayment
      end
    end
  end
end
