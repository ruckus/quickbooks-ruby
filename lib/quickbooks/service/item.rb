module Quickbooks
  module Service
    class Item < BaseService

      def delete(item)
        item.active = false
        update(item, :sparse => true)
      end

      def fetch_by_id(id, params = {})
        url = "#{url_for_base}/item/#{id}"
        fetch_object(model, url, params)
      end

      private

      def model
        Quickbooks::Model::Item
      end
    end
  end
end
