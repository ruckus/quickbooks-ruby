module Quickbooks
  module Service
    class PurchaseOrder < BaseService

      def delete(purchase_order)
        delete_by_query_string(purchase_order)
      end

    private

      def model
        Quickbooks::Model::PurchaseOrder
      end
    end
  end
end
