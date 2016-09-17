module Quickbooks
  module Service
    class ChangeService < BaseService

      def url_for_query(query = nil, start_position = 1, max_results = 20)
        q = entity
        q = "#{q}&#{query}" if query.present?

        "#{url_for_base}/cdc?entities=#{q}"
      end

      def since(timestamp)
        query("changedSince=#{URI.encode_www_form_component(timestamp.iso8601)}")
      end

      private

      def entity
        raise NotImplementedError
      end

      def model
        raise NotImplementedError
      end

    end
  end
end
