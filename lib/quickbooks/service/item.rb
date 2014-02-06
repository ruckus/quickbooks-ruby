module Quickbooks
  module Service
    class Item < BaseService

      def delete(item)
        item.active = false
        update(item, :sparse => true)
      end

      private

      def default_model_query
        "SELECT * FROM ITEM"
      end

      def model
        Quickbooks::Model::Item
      end
    end
  end
end