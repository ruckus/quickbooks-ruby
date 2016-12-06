module Quickbooks
  module Service
    class ExchangeRate < BaseService

      def fetch_by_currency(source_currency_code, as_of_date = nil)
        url = url_for_resource(model::REST_RESOURCE)
        params = { sourcecurrencycode: source_currency_code }
        params[:asofdate] = as_of_date unless as_of_date.nil?

        response = do_http_get(url, params)
        if response.code.to_i == 200
          model.from_xml(parse_singular_entity_response(model, response.plain_body))
        else
          nil
        end
      end

      private

      def model
        Quickbooks::Model::ExchangeRate
      end
    end
  end
end
