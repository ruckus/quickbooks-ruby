module Quickbooks
  module Service
    class Item < BaseService

      def delete(item)
        item.active = false
        update(item, :sparse => true)
      end

      private

      def model
        Quickbooks::Model::Item
      end
    end
  end
end
