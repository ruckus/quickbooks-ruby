module Quickbooks
  module Service
    class BaseServiceJSON < BaseService
      include ServiceCrudJSON
      HTTP_CONTENT_TYPE = 'application/json'
      HTTP_ACCEPT = 'application/json'
      attr_reader :last_response_json

      private

      # Intuit typical response:
      # {"Fault":{"Error":[{"Message":"Duplicate Name Exists Error","Detail":"The name supplied already exists. : null","code":"6240"}],"type":"ValidationFault"},"time":"2024-06-23T04:29:11.688-07:00"}
      #
      # Intuit intermittently returns an alternate response:
      # {"fault":{"error":[{"message":"Duplicate Name Exists Error","detail":"The name supplied already exists. : null","code":"6240"}],"type":"ValidationFault"},"batchItemResponse":[],"attachableResponse":[],"time":1719142418269,"cdcresponse":[]}
      def dereference_response(hsh, key)
        hsh[key] || hsh[key.downcase]
      end

      def parse_json(json)
        @last_response_json = json
      end

      def response_is_error?
        dereference_response(@last_response_json, 'Fault').present?
      end

      def parse_intuit_error
        error = {:message => "", :detail => "", :type => nil, :code => 0}
        resp = JSON.parse(@last_response_json)
        fault = dereference_response(resp, 'Fault')
        if fault.present?
          error[:type] = fault['type'] if fault.has_key?('type')
          if fault_error = dereference_response(fault, 'Error')
            error[:message] = dereference_response(fault_error, 'Message')
            error[:detail] = dereference_response(fault_error, 'Detail')
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
