module Quickbooks
  module Service
    class BaseServiceJSON < BaseService
      include ServiceCrudJSON
      HTTP_CONTENT_TYPE = 'application/json'
      HTTP_ACCEPT = 'application/json'
      attr_reader :last_response_json

      private

      def parse_json(json)
        @last_response_json = json
      end

      def response_is_error?
        @last_response_json['Fault'].present?
      end

      def parse_intuit_error
        error = {:message => "", :detail => "", :type => nil, :code => 0}
        resp = JSON.parse(@last_response_json)
        fault = resp['Fault']
        if fault.present?
          error[:type] = fault['type'] if fault.has_key?('type')
          if fault_error = fault['Error'].first
            error[:message] = fault_error['Message']
            error[:detail] = fault_error['Detail']
            error[:code] = fault_error['code']
          end
        end
        error
      rescue Exception => exception
        error[:detail] = @last_response_json.to_s
        error
      end

    end
  end
end
