module Quickbooks
  module Service
    class TaxService
      include Quickbooks::Util::Logging

      attr_accessor :company_id
      attr_accessor :oauth
      attr_reader :base_uri
      attr_reader :last_response_json

      HTTP_CONTENT_TYPE = 'application/json'
      HTTP_ACCEPT = 'application/json'
      HTTP_ACCEPT_ENCODING = 'gzip, deflate'
      BASE_DOMAIN = 'quickbooks.api.intuit.com'
      SANDBOX_DOMAIN = 'sandbox-quickbooks.api.intuit.com'
      REST_RESOURCE = "taxservice/taxcode"

      def initialize(attributes = {})
        domain = Quickbooks.sandbox_mode ? SANDBOX_DOMAIN : BASE_DOMAIN
        @base_uri = "https://#{domain}/v3/company"
        attributes.each {|key, value| public_send("#{key}=", value) }
      end

      def access_token=(token)
        @oauth = token
      end

      def company_id=(company_id)
        @company_id = company_id
      end

      # realm & company are synonymous
      def realm_id=(company_id)
        @company_id = company_id
      end

      def url_for_resource
        "#{url_for_base}/#{REST_RESOURCE}"
      end

      def url_for_base
        raise MissingRealmError.new unless @company_id
        "#{@base_uri}/#{@company_id}"
      end

      def default_model_query
        "SELECT * FROM #{self.class.name.split("::").last}"
      end

      def create(entity, options = {})
        raise Quickbooks::InvalidModelException.new(entity.errors.full_messages.join(',')) unless entity.valid?
        response = do_http(:post, url_for_resource, entity.to_json, options)
        if response.code.to_i == 200
          Quickbooks::Model::TaxService.from_json(response.plain_body)
        else
          nil
        end
      end

      private

      def parse_json(json)
        @last_response_json = json
      end

      def do_http(method, url, body, headers) # throws IntuitRequestException
        if @oauth.nil?
          raise "OAuth client has not been initialized. Initialize with setter access_token="
        end
        unless headers.has_key?('Content-Type')
          headers['Content-Type'] = HTTP_CONTENT_TYPE
        end
        unless headers.has_key?('Accept')
          headers['Accept'] = HTTP_ACCEPT
        end
        unless headers.has_key?('Accept-Encoding')
          headers['Accept-Encoding'] = HTTP_ACCEPT_ENCODING
        end

        log "------ QUICKBOOKS-RUBY REQUEST ------"
        log "METHOD = #{method}"
        log "RESOURCE = #{url}"
        log "REQUEST BODY:"
        log "#{body.inspect}"
        log "REQUEST HEADERS = #{headers.inspect}"

        response = case method
        when :post
          @oauth.post(url, body, headers)
        else
          raise "Do not know how to perform that HTTP operation"
        end
        check_response(response)
      end

      def check_response(response)
        log "------ QUICKBOOKS-RUBY RESPONSE ------"
        log "RESPONSE CODE = #{response.code}"
        log "RESPONSE BODY:"
        log ">>>>#{response.plain_body.inspect}"
        parse_json(response.plain_body)
        status = response.code.to_i
        case status
        when 200
          # even HTTP 200 can contain an error, so we always have to peek for an Error
          if response_is_error?
            parse_and_raise_exception
          else
            response
          end
        when 302
          raise "Unhandled HTTP Redirect"
        when 401
          raise Quickbooks::AuthorizationFailure
        when 403
          raise Quickbooks::Forbidden
        when 400, 500
          parse_and_raise_exception
        when 503, 504
          raise Quickbooks::ServiceUnavailable
        else
          raise "HTTP Error Code: #{status}, Msg: #{response.plain_body}"
        end
      end

      def response_is_error?
        @last_response_json['Fault'].present?
      end

      def parse_and_raise_exception
        err = parse_intuit_error
        ex = Quickbooks::IntuitRequestException.new("#{err[:message]}:\n\t#{err[:detail]}")
        ex.code = err[:code]
        ex.detail = err[:detail]
        ex.type = err[:type]
        raise ex
      end

      def parse_intuit_error
        error = {:message => "", :detail => "", :type => nil, :code => 0}
        fault = @last_response_json['Fault']
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

      private

      def model
        Quickbooks::Model::TaxService
      end
    end
  end
end
