#require 'rexml/document'
require 'uri'
require 'cgi'

class IntuitRequestException < StandardError
  attr_accessor :message, :code, :detail, :type
  def initialize(msg)
    self.message = msg
    super(msg)
  end
end
class AuthorizationFailure < StandardError; end

module Quickbooks
  module Service
    class BaseService
      include Quickbooks::Util::Logging

      attr_accessor :company_id
      attr_accessor :oauth
      attr_reader :base_uri
      attr_reader :last_response_body
      attr_reader :last_response_xml

      XML_NS = %{xmlns="http://schema.intuit.com/finance/v3"}
      HTTP_CONTENT_TYPE = 'application/xml'
      HTTP_ACCEPT = 'application/xml'

      def initialize()
        @base_uri = 'https://qb.sbfinance.intuit.com/v3/company'
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

      def url_for_resource(resource)
        "#{url_for_base}/#{resource}"
      end

      def url_for_base
        "#{@base_uri}/#{@company_id}"
      end

      private

      def parse_xml(xml)
        @last_response_xml =
        begin
          x = Nokogiri::XML(xml)
          #x.document.remove_namespaces!
          x
        end
      end

      def valid_xml_document(xml)
        %Q{<?xml version="1.0" encoding="utf-8"?>\n#{xml.strip}}
      end

      # A single object response is the same as a collection response except
      # it just has a single main element
      def fetch_object(model, url, params = {}, options = {})
        raise ArgumentError, "missing model to instantiate" if model.nil?
        response = do_http_get(url, params)
        collection = parse_collection(response, model)
        if collection.is_a?(Quickbooks::Collection)
          collection.entries.first
        else
          nil
        end
      end

      def fetch_collection(query, model, options = {})
        page = options.fetch(:page, 1)
        per_page = options.fetch(:per_page, 20)

        start_position = (page - 1) * per_page
        max_results = (page * per_page)

        query = "#{query} STARTPOSITION #{start_position} MAXRESULTS #{max_results}"
        response = do_http_get(url_for_query(query))

        parse_collection(response, model)
      end

      def url_for_query(query)
        "#{url_for_base}/query?query=#{URI.encode(query)}"
      end
      #
      # def fetch_collection2(model, custom_field_query = nil, filters = [], page = 1, per_page = 20, sort = nil, options ={})
      #   raise ArgumentError, "missing model to instantiate" if model.nil?
      #
      #   post_body_tags = []
      #
      #   # pagination parameters must come first
      #   post_body_tags << "<StartPage>#{page}</StartPage>"
      #   post_body_tags << "<ChunkSize>#{per_page}</ChunkSize>"
      #
      #   # ... followed by any filters
      #   if filters.is_a?(Array) && filters.length > 0
      #     filters = enforce_filter_order(filters).compact
      #     post_body_tags << filters.collect { |f| f.to_xml }
      #     post_body_tags.flatten!
      #   end
      #
      #   if sort
      #     post_body_tags << sort.to_xml
      #   end
      #
      #   post_body_tags << custom_field_query
      #
      #   xml_query_tag = "#{model::XML_NODE}Query"
      #   body = %Q{<?xml version="1.0" encoding="utf-8"?>\n<#{xml_query_tag} xmlns="http://www.intuit.com/sb/cdm/v2">#{post_body_tags.join}</#{xml_query_tag}>}
      #
      #   response = do_http_post(url_for_resource(model::REST_RESOURCE), body, {}, {'Content-Type' => 'text/xml'})
      #   parse_collection(response, model)
      # end

      def parse_collection(response, model)
        if response
          collection = Quickbooks::Collection.new
          xml = @last_response_xml
          begin
            results = []

            query_response = xml.xpath("//xmlns:IntuitResponse/xmlns:QueryResponse")[0]
            if query_response
              collection.start_position = query_response.attributes['startPosition'].value
              collection.max_results = query_response.attributes['maxResults'].value
            end

            path_to_nodes = "//xmlns:IntuitResponse/xmlns:#{model::XML_NODE}"
            collection.count = xml.xpath(path_to_nodes).count
            if collection.count > 0
              xml.xpath(path_to_nodes).each do |xa|
                entry = model.from_xml(xa)
                results << entry
              end
            end
            collection.entries = results
          rescue => ex
            #log("Error parsing XML: #{ex.message}")
            raise IntuitRequestException.new("Error parsing XML: #{ex.message}")
          end
          collection
        else
          nil
        end
      end

      def perform_write(model, body = "", params = {}, headers = {})
        url = url_for_resource(model::REST_RESOURCE)
        unless headers.has_key?('Content-Type')
          headers['Content-Type'] = 'text/xml'
        end
        response = do_http_post(url, body.strip, params, headers)

        result = nil
        if response
          case response.code.to_i
          when 200
            result = Quickbooks::Model::RestResponse.from_xml(response.body)
          when 401
            raise IntuitRequestException.new("Authorization failure: token timed out?")
          when 404
            raise IntuitRequestException.new("Resource Not Found: Check URL and try again")
          end
        end
        result
      end

      def do_http_post(url, body = "", params = {}, headers = {}) # throws IntuitRequestException
        url = add_query_string_to_url(url, params)
        do_http(:post, url, body, headers)
      end

      def do_http_get(url, params = {}, headers = {}) # throws IntuitRequestException
        do_http(:get, url, {}, headers)
      end

      def do_http(method, url, body, headers) # throws IntuitRequestException
        if @oauth.nil?
          raise "OAuth client has not been initialized. Initialize with setter access_token="
        end
        unless headers.has_key?('Content-Type')
          headers.merge!({'Content-Type' => HTTP_CONTENT_TYPE})
        end
        # log "------ New Request ------"
        # log "METHOD = #{method}"
        # log "RESOURCE = #{url}"
        # log "BODY(#{body.class}) = #{body == nil ? "<NIL>" : body.inspect}"
        # log "HEADERS = #{headers.inspect}"
        response = @oauth.request(method, url, body, headers)
        check_response(response)
      end

      def add_query_string_to_url(url, params)
        if params.is_a?(Hash) && !params.empty?
          url + "?" + params.collect { |k| "#{k.first}=#{k.last}" }.join("&")
        else
          url
        end
      end

      def check_response(response)
        # puts "RESPONSE CODE = #{response.code}"
        # puts "RESPONSE BODY = #{response.body}"
        parse_xml(response.body)
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
          raise AuthorizationFailure
        when 400, 500
          parse_and_raise_exception
        else
          raise "HTTP Error Code: #{status}, Msg: #{response.body}"
        end
      end

      def parse_and_raise_exception
        err = parse_intuit_error
        ex = IntuitRequestException.new(err[:message])
        ex.code = err[:code]
        ex.detail = err[:detail]
        ex.type = err[:type]

        raise ex
      end

      def response_is_error?
        @last_response_xml.xpath("//xmlns:IntuitResponse/xmlns:Fault")[0] != nil
      end

      def parse_intuit_error
        error = {:message => "", :detail => "", :type => nil, :code => 0}
        fault = @last_response_xml.xpath("//xmlns:IntuitResponse/xmlns:Fault")[0]
        if fault
          error[:type] = fault.attributes['type'].value

          error_element = fault.xpath("//xmlns:Error")[0]
          if error_element
            error[:code] = error_element.attributes['code'].value
            error[:message] = error_element.xpath("//xmlns:Message").text
            error[:detail] = error_element.xpath("//xmlns:Detail").text
          end
        end

        error
      end

    end
  end
end
