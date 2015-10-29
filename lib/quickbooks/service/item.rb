module Quickbooks
  module Service
    class Item < BaseService
      MINORVERSION = 4
      def delete(item)
        item.active = false
        update(item, :sparse => true)
      end

      def url_for_resource(resource)
        url = super(resource)
        url + "?minorversion=%d" % MINORVERSION
      end

      def url_for_query(query = nil, start_position = 1, max_results = 20)
        url = super(query, start_position, max_results)
        url + "&minorversion=%d" % MINORVERSION
      end

      private

      def model
        Quickbooks::Model::Item
      end
    end
  end
end
