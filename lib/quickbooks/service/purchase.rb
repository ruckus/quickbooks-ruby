module Quickbooks
  module Service
    class Purchase < BaseService

      def delete(purchase)
        delete_by_query_string(purchase)
      end

      private

      def model
        Quickbooks::Model::Purchase
      end
    end
  end
end
