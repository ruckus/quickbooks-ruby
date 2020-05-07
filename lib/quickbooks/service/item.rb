module Quickbooks
  module Service
    class Item < BaseService

      def delete(item)
        item.active = false
        update(item, :sparse => true)
      end

      def url_for_resource(resource)
        super(resource)
      end

      def fetch_by_id(id, params = {})
        url = "#{url_for_base}/item/#{id}"
        fetch_object(model, url, params)
      end

      def url_for_query(query = nil, start_position = 1, max_results = 20, options = {})
        super(query, start_position, max_results, options)
      end

      private

      def model
        Quickbooks::Model::Item
      end
    end
  end
end
