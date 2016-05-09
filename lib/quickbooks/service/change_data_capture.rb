module Quickbooks
  module Service
    class ChangeDataCapture < BaseService

      def url_for_query(entity_list, query=nil)
        q = entity_list.join(",")
        q = "#{q}&#{query}" if query.present?
        return "#{url_for_base}/cdc?entities=#{q}"
      end

      def since(entity_list, timestamp)
        do_http_get(url_for_query(entity_list, "changedSince=#{URI.encode_www_form_component(timestamp.iso8601)}"))
        model.new(:xml => @last_response_xml)
      end

      private

      def model
        Quickbooks::Model::ChangeDataCapture
      end

    end
  end
end
